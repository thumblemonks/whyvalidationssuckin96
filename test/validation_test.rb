require 'teststrap'

context "validation" do
  setup do
    WhyValidationsSuckIn96::Validation.new_subclass(:validates_rockingness, {}, lambda {})
  end
  
  should "have a readable string returned by inspect" do
    topic.new(Object.new).inspect
  end.equals(/^#<WhyValidationsSuckIn96::Validation subclass for validating 'validates_rockingness'>/)
  
end # validation