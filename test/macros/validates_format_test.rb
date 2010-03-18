require 'teststrap'

context "validates format" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods.map {|im| im.to_s}
  end.includes('validates_format_of')
  
  should "raise if a :with option is not given" do
      WhyValidationsSuckIn96::ValidatesFormat.new(Object.new, :attribute => :colour)    
  end.raises(ArgumentError, "Regular expression to check against must be given as :with")
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesFormat.new(Object.new, :attribute => :colour, :with => /\d{3}/)
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("does not match the given format")
  end # with some default options
  
  context "validating an object" do

    should "fail if given attribute does not match the regular expression" do
      validation = WhyValidationsSuckIn96::ValidatesFormat.new(OpenStruct.new(:number => "1"), :attribute => :number,
                                                               :with => /\d{3}/)
      validation.validates?
    end.equals(false)
    
    should "pass if given attribute matches the regular expression" do
      validation = WhyValidationsSuckIn96::ValidatesFormat.new(OpenStruct.new(:number => "111"), :attribute => :number,
                                                               :with => /\d{3}/)
      validation.validates?
    end
    
    should "to_s the attribute when checking validity" do
      validation = WhyValidationsSuckIn96::ValidatesFormat.new(OpenStruct.new(:number => 333), :attribute => :number,
                                                               :with => /\d{3}/)
      validation.validates?
    end
  end   # validating an object
end     # validates format