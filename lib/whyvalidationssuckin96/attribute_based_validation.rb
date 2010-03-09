module WhyValidationsSuckIn96
  # A mixin to help handle the most common case of validating a single attribute on an object. This module has a
  # dependency on SkippableValidation that will most likely be removed in future releases, but is something to be
  # aware of currently.
  module AttributeBasedValidation

    # An initializer for a validation that checks to see if the required options have been passed for
    # attribute based validation to work as expected.
    # @param  [Object] validatable                An object to be validated
    # @param  [Hash]   options                    The options to set up the validation with
    # @option options  [Symbol]      :attribute   The attribute on the validatable object to validate against
    # @option options  [true, false] :array       Specifies the attribute is an array of values to validate individually
    # @option options  [true, false] :allow_nil   If true, skips validation of the value of the attribute is #nil?
    # @option options  [true, false] :allow_blank If true, skips validation of the value of the attribute is #blank?
    # @option options  [true, false] :allow_empty If true, along with :array, skips validation if the array is empty
    def initialize(validatable, options = {})
      raise(ArgumentError, "The attribute to validate must be specified as :attribute") unless options[:attribute]
      @pos = 0 if options[:array]
      super
    end

    # The attribute to validate against
    def attribute
      options[:attribute]
    end

    # The value of the attribute to validate against
    def attribute_value
      if options[:array]
        validatable.send(options[:attribute])[@pos]
      else
        validatable.send(options[:attribute])
      end
    end

    # A default validate implementation that skips on #nil?/#blank? attribute values if :allow_nil or :allow_blank
    # have been set.
    def validate
      skip if skip_on_empty? || skip_on_blank? || skip_on_nil?
      super
    end

    # Performs the validation, returning true or false if the validation passes or fails,
    # or nil if the validation will not run.
    # @return [true, false, nil]
    def validates?
      if options[:array]
        return @passed = nil if skip_on_empty?
        reset
        @pos = 0
        statuses = []
        while validating?
          status = super
          @pos += 1
          statuses << status
        end
        @passed = statuses.all?
      else
        super
      end
    end

  private

    def validating?
      (@pos + 1) <= Array(validatable.send(options[:attribute])).size
    end

    def skip_on_empty?
      options[:array] && options[:allow_empty] && Array(validatable.send(options[:attribute])).empty?
    end

    def skip_on_nil?
      options[:allow_nil] && attribute_value.nil?
    end

    def skip_on_blank?
      options[:allow_blank] && attribute_value.blank?
    end
  end # AttributeBasedValidation
end   # WhyValidationsSuckIn96