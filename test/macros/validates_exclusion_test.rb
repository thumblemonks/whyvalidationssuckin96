require 'teststrap'

context "validates exclusion" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods
  end.includes('validates_exclusion_of')
  
  should "raise if an :in option is not given" do
      WhyValidationsSuckIn96::ValidatesExclusion.new(Object.new, :attribute => :colour)    
  end.raises(ArgumentError, "Collection to check for exclusion against should be specified with :in")
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesExclusion.new(Object.new, :attribute => :colour, :in => %w[1 2 3])
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("is in the excluded collection")
  end # with some default options
  
  context "validating an object" do
    
    should "fail if the attribute is in the excluded set" do
      validation = WhyValidationsSuckIn96::ValidatesExclusion.new(OpenStruct.new(:colour => "red"), :attribute => :colour,
                                                                  :in => %w[red blue])
      validation.validates?
    end.equals(false)
    
    should "pass if the attribute is out of the excluded set" do
      validation = WhyValidationsSuckIn96::ValidatesExclusion.new(OpenStruct.new(:colour => "red"), :attribute => :colour,
                                                                  :in => %w[green blue])
      validation.validates?
    end
  end   # validating an object
end     # validates exclusion