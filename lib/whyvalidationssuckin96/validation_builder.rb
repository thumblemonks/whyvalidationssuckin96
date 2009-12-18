require 'whyvalidationssuckin96/validation'

module WhyValidationsSuckIn96
  class ValidationBuilder
    
    def initialize(klass_or_mod, definition_block)
      @klass_or_mod = klass_or_mod
      @definition_block = definition_block
    end
    
    def create_validations!
      instance_eval(&@definition_block)
    end
  
    def self.register_macro(macro_name, validation_class)
      define_method(macro_name) do |*args|
        attrs, options = extract_options(args)
        attrs.each do |attr|
          add_validation(validation_class, options.merge(:attribute => attr))
        end
      end
    end
    
  private
  
    def add_validation(klass, options)
      @klass_or_mod.validation_collection << [klass, options]
    end
    
    def validate(validation_name, options = {}, &def_block)
      existing = @klass_or_mod.validation_collection.detect do |validation, opts|
        validation.name == validation_name
      end
      
      if existing
        @klass_or_mod.validation_collection.delete(existing)
      end
      
      add_validation(new_validation(validation_name, def_block), options)
    end
    
    def extract_options(args_array)
      args, opts = args_array.last.is_a?(Hash) ? [args_array[0..-2], args_array.last] : [args_array, {}]
    end
    
    def new_validation(validation_name, def_block)
      WhyValidationsSuckIn96::Validation.new_subclass(validation_name, def_block)
    end
    
  end # ValidationBuilder
end   # WhyValidationsSuckIn96
