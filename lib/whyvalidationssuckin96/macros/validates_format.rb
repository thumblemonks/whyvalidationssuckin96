require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesFormat < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "does not match the given format"}
    
    def initialize(validatable, options = {})
      super
      raise(ArgumentError, "Regular expression to check against must be given as :with") unless options[:with]
    end
    
    def validate
      super
      if attribute_value.to_s =~ options[:with]
        pass
      else
        fail
      end
    end

  end # Validation

  ValidationBuilder.register_macro :validates_format_of, WhyValidationsSuckIn96::ValidatesFormat
end   # WhyValidationsSuckIn96