require 'teststrap'

context "validates inclusion" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods
  end.includes('validates_inclusion_of')
  
  should "raise if an :in option is not given" do
      WhyValidationsSuckIn96::ValidatesInclusion.new(Object.new, :attribute => :colour)    
  end.raises(ArgumentError, "Collection to check for inclusion against should be specified with :in")
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesInclusion.new(Object.new, :attribute => :colour, :in => %w[1 2 3])
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("is not in the acceptable collection")
  end # with some default options
  
  context "validating an object" do
    
    should "fail if the attribute is not in the given set" do
      validation = WhyValidationsSuckIn96::ValidatesInclusion.new(OpenStruct.new(:colour => "red"), :attribute => :colour,
                                                                  :in => %w[blue green])
      validation.validates?
    end.equals(false)
    
    should "pass if the attribute is in the given set" do
      validation = WhyValidationsSuckIn96::ValidatesInclusion.new(OpenStruct.new(:colour => "red"), :attribute => :colour,
                                                                  :in => %w[red green blue])
      validation.validates?
    end
  end   # validating an object
end     # validates inclusion