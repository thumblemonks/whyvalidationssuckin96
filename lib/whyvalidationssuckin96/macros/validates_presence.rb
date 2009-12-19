require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesPresence < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "is not present"}
    
    def validate
      super
      if attribute_value.blank?
        fail
      else
        pass
      end
    end

  end # Validation

  ValidationBuilder.register_macro :validates_presence_of, WhyValidationsSuckIn96::ValidatesPresence
end   # WhyValidationsSuckIn96