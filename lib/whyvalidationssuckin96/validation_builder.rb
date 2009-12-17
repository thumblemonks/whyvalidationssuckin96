require 'whyvalidationssuckin96/validation'

module WhyValidationsSuckIn96
  class ValidationBuilder
    
    def initialize(klass_or_mod, definition_block)
      @klass_or_mod = klass_or_mod
      @definition_block = definition_block
      @defined_validations = {}
    end
    
    def create_validations!
      instance_eval(&@definition_block)
      @klass_or_mod.validation_collection.merge!(@defined_validations)
    end
  
  private
  
    def validate(validation_name, options = {}, &def_block)
      @defined_validations[validation_name.to_sym] = new_validation(validation_name, options, def_block)
    end
    
    
    def new_validation(validation_name, options, def_block)
      WhyValidationsSuckIn96::Validation.new_subclass(validation_name, options, def_block)
    end
    
  end # ValidationBuilder
end   # WhyValidationsSuckIn96
