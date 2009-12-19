require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesNumericality < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "is not a numerical value"}
    StripNonNumeric = /[^-+e\d.]/im
    ValidNumericChars = /\A[-+e\d.,\s]+\Z/im
    
    def validate
      super
      if options[:only_integer]
        validate_as_integer
      else
        validate_as_float
      end
    end

  private

    def validate_as_integer
      fail if attribute_value.to_s !~ ValidNumericChars
      Integer(attribute_value.to_s.gsub(StripNonNumeric, ""))
      pass
    rescue ArgumentError, TypeError
      fail
    end
    
    def validate_as_float
      fail if attribute_value.to_s !~ ValidNumericChars
      Kernel.Float(attribute_value.to_s.gsub(StripNonNumeric, ""))
      pass
    rescue ArgumentError, TypeError
      fail
    end
    
  end # Validation

  ValidationBuilder.register_macro :validates_numericality_of, WhyValidationsSuckIn96::ValidatesNumericality
end   # WhyValidationsSuckIn96