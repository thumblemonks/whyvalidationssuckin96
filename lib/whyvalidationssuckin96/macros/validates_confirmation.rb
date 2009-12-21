require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks the validity of an attribute against a confirmation field. Note that this validation does
  # not set up the confirmation field on the object, leaving this up to the implementer.
  #
  # @example Default usage
  #   class Account
  #     attr_accessor :password, :password_confirmation
  #     setup_validations do
  #       validates_confirmation_of :password
  #     end
  #   end
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