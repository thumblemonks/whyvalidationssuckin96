require 'teststrap'
require 'whyvalidationssuckin96/test/riot'

context "validation macro assertions" do
  
  context "being registered" do
    setup do
      WhyValidationsSuckIn96::ValidationBuilder::RegisteredMacros
    end
  
    should "actually have more than one registered macro to ensure these tests are valid" do
      topic.size > 1
    end

    should "add a riot assertion macro for each registered validation" do
      WhyValidationsSuckIn96::ValidationBuilder::RegisteredMacros.keys.all? do |k|
        Riot::Assertion.macros.has_key?(k.to_s)
      end
    end
  end # being registered
  
  context "asserting against a class" do
    setup do 
      klass = Class.new do
        include WhyValidationsSuckIn96::ValidationSupport
        setup_validations do
          validates_format_of :foo, :with => /[a-z]/
        end
      end
      
      Riot::Assertion.new("test") { klass }
    end
    
    should "fail if there's no validation against the specified attribute" do
      topic.validates_format_of(:ministry).run(Riot::Situation.new).first
    end.equals(:fail)
    
    should "fail if there's a validation against the specified attribute but no options are specified" do
      topic.validates_format_of(:foo).run(Riot::Situation.new).first
    end.equals(:fail)
    
    should "fail if there's a validation against the specified attribute but bad options are specified" do
      topic.validates_format_of(:foo, :with => //).run(Riot::Situation.new).first
    end.equals(:fail)
    
    should "pass if there's a validation against the specified attribute and good options are specified" do
      topic.validates_format_of(:foo, :with => /[a-z]/).run(Riot::Situation.new).first
    end.equals(:pass)

  end # asserting against a class
end   # validation macro assertions