require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks the validity of any associated objects, such as an ActiveRecord association.
  #
  # @example Checking the validity of an associated collection of tracks
  #   setup_validations do
  #     validates_associated :tracks
  #   end
  #
  # @example Checking the validity of an associated artist
  #   setup_validations do
  #     validates_associated :artist
  #   end
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