module WhyValidationsSuckIn96
  module Test
    module Riot
      class ValidationAssertionMacro < ::Riot::AssertionMacro
        class << self
          attr_accessor :validation_macro_name
        end
        
        WhyValidationsSuckIn96::ValidationBuilder::RegisteredMacros.keys.each do |macro_name|
          Class.new(self) do
            self.validation_macro_name = macro_name
            register macro_name
          end
        end
        
        def evaluate(model, *validation_args)
          attribute, options = validation_args
          if has_validation?(model, attribute, options || {})
            pass("#{model} #{validation_macro_name} #{attribute}")
          else
            fail("expected #{model} to #{validation_macro_name} #{attribute}")
          end
        end
        
        def validation_macro_name
          self.class.validation_macro_name
        end
        
      private
      
        def has_validation?(klass, attribute, validation_opts)
          v_klass = WhyValidationsSuckIn96::ValidationBuilder::RegisteredMacros[validation_macro_name]
          raise "No registered validation exists for #{validation_macro_name}" unless v_klass
          klass.validation_collection.any? do |(vc,opts)|
            vc == v_klass && opts.all? do |k,v| 
              # @todo - this is a hack to skip the attribute based validation options
              next(true) if k == :attribute && v == attribute
              validation_opts[k] == v
            end
          end
        end
        
      end # ValidationAssertionMacro
    end   # Riot
  end     # Test
end       # WhyValidationsSuckIn96