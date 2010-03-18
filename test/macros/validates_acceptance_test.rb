require 'teststrap'

context "validates acceptance" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods.map {|im| im.to_s}
  end.includes('validates_acceptance_of')
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesAcceptance.new(Object.new, :attribute => :accepted)
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("must be accepted")
  
    should "default the :allow_nil option to true" do
      topic.options[:allow_nil]
    end

    should "default the :accept option to allow the string '1'" do
      topic.options[:accept]
    end.equals("1")
  end # with some default options
  
  context "validating an object" do
    validatable = OpenStruct.new(:accepted => false)
    
    setup do
      WhyValidationsSuckIn96::ValidatesAcceptance.new(validatable, :attribute => :accepted)
    end
    
    should "fail if the return value of the given attribute doesnt match the :accept option" do
      validatable.accepted = false
      topic.validates?
    end.equals(false)
    
    should "pass if the return value of the given attribute matches the :accept option" do
      validatable.accepted = topic.options[:accept]
      topic.validates?
    end
    
    context "with some non-default options" do
      setup do
        WhyValidationsSuckIn96::ValidatesAcceptance.new(validatable, :attribute => :accepted, :accept => :what, :message => "bleh")
      end

      should "have a different message" do
        topic.message
      end.equals("bleh")
      
      should "fail if the return value of the given attribute doesnt match the :accept option" do
        validatable.accepted = false
        topic.validates?
      end.equals(false)
      
      should "pass if the return value of the given attribute matches the :accept option" do
        validatable.accepted = :what
        topic.validates?
      end
    end # with some non-default options
  end   # validating an object
end     # validates acceptance