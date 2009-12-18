module WhyValidationsSuckIn96
  class Validation
    class << self
      attr_accessor :name, :options
    end
    
    def initialize(validatable)
      @validatable = validatable
    end
    
    def self.new_subclass(name, options, def_block)
      Class.new(self) do
        self.name = name.to_sym
        self.options = options
        define_method(:validate, &def_block)
        private :validate
      end
    end
    
    def passed?
      @passed == true
    end
    
    def failed?
      @passed == false
    end
    
    def validates?
      reset
      @passed = catch :validation_done do
        validate(@validatable)
        pass
      end
    end
    
    def inspect
      "#<WhyValidationsSuckIn96::Validation subclass for validating '#{self.class.name}'> #{super}"
    end
    
    def options
      @options ||= self.class.options.dup
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