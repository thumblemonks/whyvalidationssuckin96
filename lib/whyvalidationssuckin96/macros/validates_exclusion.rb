require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesExclusion < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "is in the excluded collection"}
    
    def initialize(validatable, options = {})
      super
      raise(ArgumentError, "Collection to check for exclusion against should be specified with :in") unless options[:in]
    end
    
    def validate
      super
      if options[:in].include?(validatable.send(attribute))
        fail
      else
        pass
      end
    end

  end # Validation

  ValidationBuilder.register_macro :validates_exclusion_of, WhyValidationsSuckIn96::ValidatesExclusion
end   # WhyValidationsSuckIn96