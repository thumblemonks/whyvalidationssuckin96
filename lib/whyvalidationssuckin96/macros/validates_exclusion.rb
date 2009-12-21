require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks the validity of an attribute against a collection of excluded values.
  #
  # @example Default usage
  #   setup_validations do
  #     validates_exclusion_of :subdomain, :in => %w[www ftp]
  #   end
  class ValidatesExclusion < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "is in the excluded collection"}
    
    # @param  [Object] validatable     An object to be validated.
    # @param  [Hash]   options         The options to set up the validation with.
    # @option options  [#include?] :in A collection to check against for exclusion.
    def initialize(validatable, options = {})
      super
      raise(ArgumentError, "Collection to check for exclusion against should be specified with :in") unless options[:in]
    end
    
    def validate
      super
      if options[:in].include?(attribute_value)
        fail
      else
        pass
      end
    end

  end # Validation

  ValidationBuilder.register_macro :validates_exclusion_of, WhyValidationsSuckIn96::ValidatesExclusion
end   # WhyValidationsSuckIn96