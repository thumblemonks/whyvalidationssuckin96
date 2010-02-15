require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96

  # Checks the validity of an date attribute against a regular expression.
  #
  # @example Default usage
  #   setup_validations do
  #     validates_as_date :start_date
  #   end
  class ValidatesDate < Validation
    attr_reader :date

    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    DefaultDelimiters = %r{[-/]}
    DefaultParser = lambda do |str|
      month, day, year = str.split(DefaultDelimiters, 3)
      {:month => month, :day => day, :year => year}
    end

    DefaultOptions = {
      :message => "does not match the given date format or is not a valid date",
      :parser => DefaultParser
    }

    # @param  [Object] validatable    An object to be validated
    # @param  [Hash]   options        The options to set up the validation with
    # @option options  [Regexp] :with A regular expression to check against
    def initialize(validatable, options = {})
      super
    end

    def validate
      super
      if parse_date
        pass
      else
        fail
      end
    rescue => e
      fail
    end

  private

    def parse_date
      parsed = options[:parser].call(attribute_value.to_s)
      @date = Date.civil(parsed[:year].to_i, parsed[:month].to_i, parsed[:day].to_i)
    end
  end # Validation

  ValidationBuilder.register_macro :validates_as_date, WhyValidationsSuckIn96::ValidatesDate
end   # WhyValidationsSuckIn96