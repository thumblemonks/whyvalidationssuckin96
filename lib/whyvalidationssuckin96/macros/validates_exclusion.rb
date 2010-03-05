require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96

  # Checks the validity of an attribute against a collection of excluded values.
  #
  # @example Default usage
  #   setup_validations do
  #     validates_exclusion_of :subdomain, :in => %w[www ftp]
  #   end
  #
  # @example Usage when checking a set of values against another set
  #   setup_validations do
  #     validates_exclusion_of :colours, :in => %w[red green], :set => true
  #     # colours can now be an array containing anything except 'red' or 'green'
  #   end
  class ValidatesExclusion < Validation
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation

    DefaultOptions = {:message => "is in the excluded collection",
                      :set     => false}

    # @param  [Object] validatable        An object to be validated.
    # @param  [Hash]   options            The options to set up the validation with.
    # @option options  [#include?]   :in  A collection to check against for exclusion.
    # @option options  [true, false] :set Whether or not to do a set based comparison
    def initialize(validatable, options = {})
      super
      raise(ArgumentError, "Collection to check for exclusion against should be specified with :in") unless options[:in]
    end

    def validate
      super
      if options[:set]
        attribute_value.any? do |val|
          options[:in].include?(val)
        end ? fail : pass
      elsif !options[:set] && options[:in].include?(attribute_value)
        fail
      else
        pass
      end
    end

  private

    def attribute_value
      options[:set] ? Array(super) : super
    end

  end # Validation

  ValidationBuilder.register_macro :validates_exclusion_of, WhyValidationsSuckIn96::ValidatesExclusion
end   # WhyValidationsSuckIn96