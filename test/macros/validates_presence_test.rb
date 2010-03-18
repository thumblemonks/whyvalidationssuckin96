require 'teststrap'

context "validates presence" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods.map {|im| im.to_s}
  end.includes('validates_presence_of')
  
  context "validating an object" do
    validatable = OpenStruct.new(:message => "foo")
    
    setup do
      WhyValidationsSuckIn96::ValidatesPresence.new(validatable, :attribute => :message)
    end
    
    should "have a message accessor with a default message" do
      topic.message
    end.equals("is not present")
    
    should "fail if the attribute is blank" do
      validatable.message = ""
      topic.validates?
    end.equals(false)
    
    should "pass if the attribute is non blank" do
      validatable.message = "blah"
      topic.validates?
    end
    
  end   # validating an object
end     # validates presence