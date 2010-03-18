require 'teststrap'

context "validates email" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods.map {|im| im.to_s}
  end.includes('validates_as_email')
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesEmail.new(Object.new, :attribute => :email)
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("is not a valid email address")
  end # with some default options
  
  context "validating an object" do    
    validatable = OpenStruct.new(:email => "")
    
    setup do
      WhyValidationsSuckIn96::ValidatesEmail.new(validatable, :attribute => :email)
    end
    
    should "allow a valid regular email address" do
      validatable.email = "foo@example.com"
      topic.validates?
    end
    
    should "allow an email address with periods" do
      validatable.email = "foo.bar@example.com"
      topic.validates?
    end
    
    should "allow an email address with a plus sign" do
      validatable.email = "foo+bar@example.com"
      topic.validates?
    end
    
    should "disallow a whack email address" do
      validatable.email = "foo"
      topic.validates?
    end.equals(false)
  end     # validating an object
end       # validates email