module WhyValidationsSuckIn96
  # A mixin to handle specifying :if and :unless options to check before performing validation.
  #
  # @example Validate if a given block returns true
  #   setup_validations do
  #     validates_associated :tracks, :if => lambda { !validatable.tracks.empty? }
  #   end
  #
  # @example Validate if a given method on the validatable object returns true
  #   setup_validations do
  #     validates_associated :tracks, :if => :allow_validation
  #   end
  #   
  #   def allow_validation
  #     false
  #   end
  #
  # @example Validate unless a given block returns true
  #   setup_validations do
  #     validates_associated :tracks, :unless => lambda { validatable.tracks.empty? }
  #   end
  #
  # @example Validate unless a given method on the validatable object returns true
  #   setup_validations do
  #     validates_associated :tracks, :unless => :disallow_validation
  #   end
  #   
  #   def disallow_validation
  #     true
  #   end
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