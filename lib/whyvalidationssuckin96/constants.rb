module WhyValidationsSuckIn96
  class ValidationError < RuntimeError
    attr_reader :invalid_object

    def initialize(message, invalid_object)
      super(message)
      @invalid_object = invalid_object
    end
  end # ValidationError
end   # WhyValidationsSuckIn96