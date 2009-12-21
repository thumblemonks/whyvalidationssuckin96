require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks for the presence of a given attribute.
  #
  # @example Default usage
  #   setup_validations do
  #     validates_presence_of :name
  #   end
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