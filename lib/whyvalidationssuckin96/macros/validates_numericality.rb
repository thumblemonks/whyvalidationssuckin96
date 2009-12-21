require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks to see if a given attribute is a valid numerical value. Allows a certain degree of latitude in determining
  # what is a valid numerical value, like allowing commas and spaces in the value for example.
  #
  # @example Default usage
  #   setup_validations do
  #     validates_numericality_of :cost
  #   end
  #
  # @example Only allow integer values
  #   setup_validations do
  #     validates_numericality_of :cost, :only_integer => true
  #   end
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