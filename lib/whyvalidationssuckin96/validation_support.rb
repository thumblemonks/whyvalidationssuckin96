require 'whyvalidationssuckin96/validation_builder'

module WhyValidationsSuckIn96
  module ValidationSupport
    
    def self.included(klass_or_mod)
      klass_or_mod.module_eval do
        class << self
          attr_accessor :validation_collection
        end
        self.validation_collection = []
        extend WhyValidationsSuckIn96::ValidationSupport::ClassMethods
        include WhyValidationsSuckIn96::ValidationSupport::InstanceMethods
      end
    end
    
    module InstanceMethods
      
      def valid?
        all_validations.all? do |validation|
          validation.passes?
        end
      end
      
      def failed_validations
        all_validations.select { |validation| validation.failed? }
      end
      
      def passed_validations
        all_validations.select { |validation| validation.passed? }
      end
      
      def all_validations
        @all_validations ||= self.class.validation_collection.collect do |vc|
          vc.new(self)
        end
      end
      
    end # InstanceMethods
    
    module ClassMethods
      
      def self.extended(klass_or_mod)
        klass_or_mod.module_eval do
          old_inherited = method(:inherited)
          (class << self; self; end).send(:define_method, :inherited) do |k_or_m|
            old_inherited(k_or_m)
            
          end
        end
      end
      
      def setup_validations(&definition_block)
        builder = ValidationBuilder.new(self, definition_block)
        builder.create_validations!
      end
      
    end # ClassMethods
  end   # ValidationSupport
end     # WhyValidationsSuckIn96