require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesAcceptance < Validation
    DefaultOptions = {:allow_nil => true, :accept => "1", :message => "must be accepted"}
    
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    def validate
      super
      if options[:accept] == attribute_value
        pass
      else
        fail
      end
    end
    
  end # Validation

  ValidationBuilder.register_macro :validates_acceptance_of, WhyValidationsSuckIn96::ValidatesAcceptance
end   # WhyValidationsSuckIn96