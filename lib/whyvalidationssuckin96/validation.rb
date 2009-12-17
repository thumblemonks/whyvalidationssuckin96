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
    
    def failed?
      @passed == false
    end
    
    def passes?
      reset
      @passed = catch :validation_done do
        validate(@validatable)
        pass unless failed?
      end
    rescue => e
      fail
      raise e
    end
    
    def inspect
      "#<WhyValidationsSuckIn96 subclass for validating '#{self.class.name}'> #{super}"
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