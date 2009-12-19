require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesInclusion < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "is not in the acceptable collection"}
    
    def initialize(validatable, options = {})
      super
      raise(ArgumentError, "Collection to check for inclusion against should be specified with :in") unless options[:in]
    end
    
    def validate
      super
      if options[:in].include?(attribute_value)
        pass
      else
        fail
      end
    end

  end # Validation

  ValidationBuilder.register_macro :validates_inclusion_of, WhyValidationsSuckIn96::ValidatesInclusion
end   # WhyValidationsSuckIn96