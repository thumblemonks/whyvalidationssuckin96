require 'whyvalidationssuckin96/validation_builder'

module WhyValidationsSuckIn96
  module ValidationSupport
    
    def self.included(klass_or_mod)
      klass_or_mod.module_eval do
        extend WhyValidationsSuckIn96::ValidationSupport::ClassMethods
        include WhyValidationsSuckIn96::ValidationSupport::InstanceMethods
      end
    end
    
    module InstanceMethods

      def invalid?
        !valid?
      end
      
      def valid?
        all_validations.all? do |validation|
          validation.validates?
        end
      end
      
      def failed_validations
        all_validations.select { |validation| validation.failed? }
      end
      
      def passed_validations
        all_validations.select { |validation| validation.passed? }
      end
      
      def all_validations
        @all_validations ||= self.class.validation_collection.values.collect do |vc|
          vc.new(self)
        end
      end
      
    end # InstanceMethods
    
    module ClassMethods
      
      def validation_collection
        @validation_collection ||= begin
          ancestor_with_validations = ancestors[1..-1].detect{|anc| anc.respond_to?(:validation_collection) }
          ancestor_with_validations ? ancestor_with_validations.validation_collection.dup : {}
        end
      end
      
      def setup_validations(&definition_block)
        self.validation_collection ||= ancestors.detect{|anc| !anc.validation_collection.nil?}.validation_collection.dup
        builder = ValidationBuilder.new(self, definition_block)
        builder.create_validations!
      end
      
    end # ClassMethods
  end   # ValidationSupport
end     # WhyValidationsSuckIn96