module WhyValidationsSuckIn96
  module SkippableValidation
    
    def validate
      skip if skip_validation?
    end
    
  private
  
    def skip
      throw :validation_done, nil
    end
    
    def skip_validation?
      skip_if? || skip_unless?
    end
    
    def skip_unless?
      return false unless options.has_key?(:unless)
      check = options[:unless].is_a?(Proc) ? instance_eval(&options[:unless]) : validatable.send(options[:unless])
      check == true
    end
    
    def skip_if?
      return false unless options.has_key?(:if)
      check = options[:if].is_a?(Proc) ? instance_eval(&options[:if]) : validatable.send(options[:if])
      check == false
    end
  end # SkippableValidation
end   # WhyValidationsSuckIn96