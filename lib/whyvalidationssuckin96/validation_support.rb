require 'whyvalidationssuckin96/validation_builder'

module WhyValidationsSuckIn96
  module ValidationSupport
    
    def self.included(klass_or_mod)
      klass_or_mod.module_eval do
        extend WhyValidationsSuckIn96::ValidationSupport::ClassMethods
        include WhyValidationsSuckIn96::ValidationSupport::InstanceMethods
      end
    end
    
    # Instance methods added to any class or module that mixes in ValidationSupport
    module InstanceMethods
      
      # Is this object invalid?
      # @return [true, false]
      def invalid?
        !valid?
      end
      
      # Is this object valid?
      # @return [true, false]
      def valid?
        all_validations.collect do |validation|
          validation.validates?
        end.all?
      end
      
      # An array of instances of failed validations
      # @return [Array]
      def failed_validations
        all_validations.select { |validation| validation.failed? }
      end
      
      # An array of instances of passed validations
      # @return [Array]
      def passed_validations
        all_validations.select { |validation| validation.passed? }
      end
      
      # An array of instances of all validations for this object
      # @return [Array]
      def all_validations
        @all_validations ||= self.class.validation_collection.collect do |(vc,opts)|
          vc.new(self, opts)
        end
      end
      
    end # InstanceMethods
    
    module ClassMethods
      
      # An array of arrays, the first element of each being the validation subclass that will be instantiated
      # when validation is performed, the last element being the options the validation will be instantiated
      # with.
      # @return [Array]
      def validation_collection
        @validation_collection ||= begin
          ancestor_with_validations = ancestors[1..-1].detect{|anc| anc.respond_to?(:validation_collection) }
          ancestor_with_validations ? ancestor_with_validations.validation_collection.dup : []
        end
      end
      
      # Sets up validations for the class or module this module has been mixed into
      def setup_validations(&definition_block)
        self.validation_collection ||= ancestors.detect{|anc| !anc.validation_collection.nil?}.validation_collection.dup
        builder = ValidationBuilder.new(self, definition_block)
        builder.create_validations!
      end
      
    end # ClassMethods
  end   # ValidationSupport
end     # WhyValidationsSuckIn96