module WhyValidationsSuckIn96
  module AttributeBasedValidation
    
    def initialize(validatable, options = {})
      raise(ArgumentError, "The attribute to validate must be specified as :attribute") unless options[:attribute]
      super
    end
    
    def attribute
      @options[:attribute]
    end
    
    def validate
debugger if $dbg
      skip if skip_on_blank? || skip_on_nil?
      super
    end
    
  private
  
    def skip_on_nil?
      @options[:allow_nil] && validatable.send(attribute).nil?
    end
    
    def skip_on_blank?
      @options[:allow_blank] && validatable.send(attribute).blank?
    end
  end # AttributeBasedValidation
end   # WhyValidationsSuckIn96