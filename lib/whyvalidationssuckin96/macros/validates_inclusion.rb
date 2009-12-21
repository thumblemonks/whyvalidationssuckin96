require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks the validity of an attribute against a list of values for it to be included in.
  #
  # @example Default usage
  #   setup_validations do
  #     validates_inclusion_of :unit_system, :in => %w[imperial metric]
  #   end
  class ValidatesInclusion < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "is not in the acceptable collection"}
    
    # @param  [Object] validatable     An object to be validated.
    # @param  [Hash]   options         The options to set up the validation with.
    # @option options  [#include?] :in A collection to check against for inclusion.
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