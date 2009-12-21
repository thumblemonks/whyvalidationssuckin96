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
    # @option options  [true, false] :allow_nil   If true, skips validation of the value of the attribute is #nil?
    # @option options  [true, false] :allow_blank If true, skips validation of the value of the attribute is #blank?
    def initialize(validatable, options = {})
      raise(ArgumentError, "The attribute to validate must be specified as :attribute") unless options[:attribute]
      super
    end
    
    # The attribute to validate against
    def attribute
      options[:attribute]
    end
    
    # The value of the attribute to validate against
    def attribute_value
      validatable.send(options[:attribute])
    end
    
    # A default validate implementation that skips on #nil?/#blank? attribute values if :allow_nil or :allow_blank
    # have been set.
    def validate
      skip if skip_on_blank? || skip_on_nil?
      super
    end
    
  private

    def skip_on_nil?
      options[:allow_nil] && attribute_value.nil?
    end
    
    def skip_on_blank?
      options[:allow_blank] && attribute_value.blank?
    end
  end # AttributeBasedValidation
end   # WhyValidationsSuckIn96