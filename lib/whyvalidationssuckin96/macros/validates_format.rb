require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks the validity of an attribute against a regular expression.
  #
  # @example Default usage
  #   setup_validations do
  #     validates_format_of :username, :with => /[a-z0-9]/i
  #   end
  class ValidatesFormat < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "does not match the given format"}
    
    # @param  [Object] validatable    An object to be validated
    # @param  [Hash]   options        The options to set up the validation with
    # @option options  [Regexp] :with A regular expression to check against
    def initialize(validatable, options = {})
      super
      raise(ArgumentError, "Regular expression to check against must be given as :with") unless options[:with]
    end
    
    def validate
      super
      if attribute_value.to_s =~ options[:with]
        pass
      else
        fail
      end
    end

  end # Validation

  ValidationBuilder.register_macro :validates_format_of, WhyValidationsSuckIn96::ValidatesFormat
end   # WhyValidationsSuckIn96