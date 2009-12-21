require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks to see if a given attribute is present in any other records in the databaser
  #
  # @example Default usage
  #   setup_validations do
  #     validates_uniqueness_of :name
  #   end
  #
  # @example Check in a case sensitive fashion
  #   setup_validations do
  #     validates_uniqueness_of :name, :case_sensitive => true
  #   end
  #
  # @example Scope uniqueness to another attribute
  #   setup_validations do
  #     validates_uniqueness_of :name, :scope => :account_id
  #   end
  #
  # @example Scope uniqueness to multiple other attributes
  #   setup_validations do
  #     validates_uniqueness_of :name, :scope => [:account_id, :domain]
  #   end
  #
  # @example When used with STI, check only uniqueness of records of the current type
  #   setup_validations do
  #     validates_uniqueness_of :name, :base_class_scope => false
  #   end
  class ValidatesUniqueness < Validation
    DefaultOptions = {:message => "has already been taken", :case_sensitive => false, :base_class_scope => true}
    
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    def validate
      super
      results = find_results
      result_ids = results.collect { |r| r[scope_primary_key] }
      if results.empty? || result_ids.include?(validatable[scope_primary_key])
        pass
      elsif !results.empty? && options[:case_sensitive]
        (results.any? { |r| r[attribute].to_s == attribute_value.to_s }) ? fail : pass
      else
        fail
      end
    end
  
  private
    
    def find_results
      scope_class.send(:with_exclusive_scope) do
        scope_class.send(:with_scope, :find => {:conditions => find_conditions}) do
          scope_class.find(:all, :conditions => scope_conditions)
        end
      end
    end
    
    def scope_columns
      Array(options[:scope])
    end
    
    def find_conditions
      ["LOWER(#{scope_class.connection.quote_column_name(attribute.to_s)}) = LOWER(?)", attribute_value]
    end
    
    def scope_conditions
      scope_columns.inject({}) do |conds,col|
        conds[col] = validatable[col]
        conds
      end
    end
    
    def scope_primary_key
      scope_class.primary_key
    end
    
    def scope_class
      options[:base_class_scope] ? validatable.class.base_class : validatable.class
    end

  end # Validation

  ValidationBuilder.register_macro :validates_uniqueness_of, WhyValidationsSuckIn96::ValidatesUniqueness
end   # WhyValidationsSuckIn96