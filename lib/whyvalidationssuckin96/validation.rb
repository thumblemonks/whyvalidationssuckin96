module WhyValidationsSuckIn96
  
  # Base class to use when implementing validations.
  class Validation
    
    # A hash of default options for the validation to use.
    DefaultOptions = {}
    
    # The options the validation was initialized with
    attr_accessor :options
    
    # The object the validation is validating
    attr_reader :validatable
    
    class << self
      attr_accessor :name
    end
    
    # @param  [Object] validatable                An object to be validated
    # @param  [Hash]   options                    The options to set up the validation with
    def initialize(validatable, options = {})
      @validatable = validatable
      @options = self.class::DefaultOptions.merge(options)
    end
    
    # Creates a new subclass of this class, used when defining custom validations with a block
    def self.new_subclass(name, def_block)
      Class.new(self) do
        self.name = name.to_sym
        define_method(:validate, &def_block)
        private :validate
    
        def inspect
          "#<WhyValidationsSuckIn96::Validation subclass for validating '#{self.class.name}'> #{super}"
        end
      end
    end
    
    # Has this validation passed?
    # @return [true, false]
    def passed?
      @passed == true
    end

    # Has this validation failed?
    # @return [true, false]
    def failed?
      @passed == false
    end
    
    # Has this validation run?
    # @return [true, false]
    def has_run?
      @passed != nil
    end
    
    # Performs the validation, returning true or false if the validation passes or fails,
    # or nil if the validation will not run.
    # @return [true, false, nil]
    def validates?
      reset
      @passed = catch :validation_done do
        validate
        pass
      end
    end
    
    # The failure message for this validation.
    def message
      @options[:message] || "failed validation"
    end
    
  private
    
    def reset
      @passed = nil
    end
    
    def pass
      throw :validation_done, true
    end
    
    def fail
      throw :validation_done, false
    end
    
  end # Validation
end   # WhyValidationsSuckIn96