require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'
require 'whyvalidationssuckin96/vendor/rfc822'

module WhyValidationsSuckIn96
  
  # Checks whether a given attribute is a valid email address
  #
  # @example Default usage
  #   setup_validations do
  #     validates_as_email :email
  #   end
  #
  class ValidatesEmail < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "is not a valid email address"}
    
    def validate
      super
      WhyValidationsSuckIn96::RFC822::EmailAddress.match(attribute_value) ? pass : fail
    end

  end # Validation

  ValidationBuilder.register_macro :validates_as_email, WhyValidationsSuckIn96::ValidatesEmail
end   # WhyValidationsSuckIn96