module WhyValidationsSuckIn96
  class Validation
    DefaultOptions = {}
    
    attr_accessor :options
    attr_reader :validatable
    
    class << self
      attr_accessor :name
    end
    
    def initialize(validatable, options = {})
      @validatable = validatable
      @options = self.class::DefaultOptions.merge(options)
    end
    
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
    
    def passed?
      @passed == true
    end
    
    def failed?
      @passed == false
    end
    
    def has_run?
      @passed != nil
    end
    
    def validates?
      reset
      @passed = catch :validation_done do
        validate
        pass
      end
    end
    
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