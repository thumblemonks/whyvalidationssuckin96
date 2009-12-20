require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesAssociated < Validation
    DefaultOptions = {:message => "is invalid"}
    
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    def validate
      super
      Array(attribute_value).collect do |assoc|
        assoc.valid?
      end.all? ? pass : fail
    end
    
  end # Validation

  ValidationBuilder.register_macro :validates_associated, WhyValidationsSuckIn96::ValidatesAssociated
end   # WhyValidationsSuckIn96