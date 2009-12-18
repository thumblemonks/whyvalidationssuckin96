require 'teststrap'

context "validates confirmation" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods
  end.includes('validates_confirmation_of')
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesConfirmation.new(Object.new, :attribute => :password)
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("does not match the confirmation")  
  end # with some default options
  
  context "validating an object" do
  
    context "without a confirmation field" do
      validatable = Class.new do
        def password
          "foo"
        end
      end.new

      setup do
        WhyValidationsSuckIn96::ValidatesConfirmation.new(validatable, :attribute => :password)
      end
      
      should "raise if a confirmation field isn't available" do
        topic.validates?
      end.raises(NoMethodError)
      
    end # without a confirmation field

    context "with a confirmation field" do
      validatable = OpenStruct.new(:password => "foo")

      setup do
        WhyValidationsSuckIn96::ValidatesConfirmation.new(validatable, :attribute => :password)
      end
      
      should "fail if field does not match the confirmation" do
        validatable.password = "foo"
        validatable.password_confirmation = "bleh"
        topic.validates?
      end.equals(false)
    
      should "pass if the field matches the confirmation" do
        validatable.password = validatable.password_confirmation = "foo"
        topic.validates?
      end
    
      should "skip the validation if the confirmation is nil" do
        validatable.password_confirmation = nil
        topic.validates?
        topic.has_run?
      end.equals(false)
    end # with a confirmation field
  end   # validating an object
end     # validates confirmation