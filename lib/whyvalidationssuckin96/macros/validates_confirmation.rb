require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesConfirmation < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "does not match the confirmation"}
    
    def validate
      super
      skip unless confirmation_value = validatable.send(confirmation_field)
      if confirmation_value == attribute_value
        pass
      else
        fail
      end
    end
    
  private
  
    def confirmation_field
      :"#{attribute}_confirmation"
    end
  end # Validation

  ValidationBuilder.register_macro :validates_confirmation_of, WhyValidationsSuckIn96::ValidatesAcceptance
end   # WhyValidationsSuckIn96