require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96

  # Checks the validity of an attribute against a list of values for it to be included in.
  #
  # @example Default usage
  #   setup_validations do
  #     validates_inclusion_of :unit_system, :in => %w[imperial metric]
  #   end
  #
  # @example Usage when checking a set of values against another set
  #   setup_validations do
  #     validates_inclusion_of :colours, :in => %w[red green], :set => true
  #     # colours can now be an array containing either 'red' or 'green' or both
  #   end
  class ValidatesInclusion < Validation
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation

    DefaultOptions = {:message => "is not in the acceptable collection",
                      :set     => false}

    # @param  [Object] validatable        An object to be validated.
    # @param  [Hash]   options            The options to set up the validation with.
    # @option options  [#include?]   :in  A collection to check against for inclusion.
    # @option options  [true, false] :set Whether or not to do a set based comparison
    def initialize(validatable, options = {})
      super
      raise(ArgumentError, "Collection to check for inclusion against should be specified with :in") unless options[:in]
    end

    def validate
      super
      if options[:set]
        attribute_value.any? && attribute_value.all? do |val|
          options[:in].include?(val)
        end ? pass : fail
      elsif !options[:set] && options[:in].include?(attribute_value)
        pass
      else
        fail
      end
    end

  private

    def attribute_value
      options[:set] ? Array(super) : super
    end
    
  end # Validation

  ValidationBuilder.register_macro :validates_inclusion_of, WhyValidationsSuckIn96::ValidatesInclusion
end   # WhyValidationsSuckIn96