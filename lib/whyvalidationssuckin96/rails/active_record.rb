require 'whyvalidationssuckin96'
require 'active_record'
require 'active_record/base'
require 'active_record/callbacks'

module WhyValidationsSuckIn96
  
  module ActiveRecord
    RemovableInstanceMethods = %w[invalid? validate_on_create validate_on_update validate errors]
    RemovableClassMethods = %w[validate validate_on_create validate_on_update validates_format_of validates_each 
                               validates_inclusion_of validates_size_of validates_confirmation_of validates_exclusion_of
                               validates_uniqueness_of validates_associated validates_acceptance_of 
                               validates_numericality_of validates_presence_of validates_length_of]
    
    def self.included(klass_or_mod)
      remove_active_record_validation_related_methods_from(klass_or_mod)
      klass_or_mod.instance_eval do
        include WhyValidationsSuckIn96::ValidationSupport
        include WhyValidationsSuckIn96::ActiveRecord::InstanceMethods
      end
    end
    
  private
  
    # FIXME - holy mother of god is this a nasty method
    def self.remove_active_record_validation_related_methods_from(klass_or_mod)
      method_map = {klass_or_mod => RemovableInstanceMethods, (class<<klass_or_mod;self;end) => RemovableClassMethods}
      method_map.each do |context, removable_methods|
        context.instance_eval do 
          removable_methods.each do |removable_method|
            begin
              remove_method removable_method
            rescue => e
              undef_method removable_method
            end
          end # removable_methods.each
        end   # context.instance_eval
      end     # method_map.each
    end
    
    module InstanceMethods    
      
      def self.included(klass_or_mod)
        klass_or_mod.module_eval do
          alias_method :valid_without_callbacks?, :valid_with_lifecycle_checking?
        end
      end

    private
    
      def validations_for_current_lifecycle
        validations_for_save + (new_record? ? validations_for_create : validations_for_update)
      end
      
      def valid_with_lifecycle_checking?
        validations_for_current_lifecycle.all? do |validation|
          validation.validates?
        end
      end
      
      def validations_for_update
        all_validations.select do |validation|
          validation.options[:on] == :update
        end
      end
      
      def validations_for_create
        all_validations.select do |validation|
          validation.options[:on] == :create
        end
      end
      
      def validations_for_save
        all_validations.select do |validation|
          validation.options[:on].nil? || validation.options[:on] == :save
        end
      end
      
    end # InstanceMethods
  end   # ActiveRecord
end     # WhyValidationsSuckIn96

module ActiveRecord
  class RecordInvalid < ActiveRecordError
    attr_reader :record
    def initialize(record)
      @record = record
      super
    end
  end # RecordInvalid
end   # ActiveRecord

ActiveRecord::Base.instance_eval { include WhyValidationsSuckIn96::ActiveRecord }