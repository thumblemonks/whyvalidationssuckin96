require 'teststrap'

context "validation" do
  context "creating a new subclass" do
    setup do
      WhyValidationsSuckIn96::Validation.new_subclass(:validates_rockingness, {:example => "stuff"}, lambda {})
    end
  
    should "have a readable string returned by inspect" do
      topic.new(Object.new).inspect
    end.equals(/^#<WhyValidationsSuckIn96::Validation subclass for validating 'validates_rockingness'>/)
    
    should "have a name on the new subclass" do
      topic.name
    end.equals(:validates_rockingness)
    
    should "have an accessor for the given options on the new subclass" do
      topic.options
    end.equals({:example => 'stuff'})
    
    should "define validate as private on the new subclass" do
      topic.private_instance_methods
    end.includes("validate")    
  end # creating a new subclass
  
  context "an instance of a subclass" do
    setup do
      WhyValidationsSuckIn96::Validation.new_subclass(:validates_rockingness, {:example => "stuff"}, lambda {})
    end
    
    should "return a true by default when pass/fail aren't called in the validation definition" do
      topic.new(Object.new).validates?
    end.equals(true)
    
    should "be passed by default when pass/fail aren't called in the validation definition" do
      validation = topic.new(Object.new)
      validation.validates?
      validation.passed?
    end.equals(true)
    
    should "not be passed if the validation hasn't run yet" do
      topic.new(Object.new).passed?
    end.equals(false)

    should "not be failed if the validation hasn't run yet" do
      topic.new(Object.new).failed?
    end.equals(false)
    
  end # an instance of a subclass
  
  context "an instance of a subclass with an actual validation definition" do
    setup do
      validation = lambda { |val| val ? pass : fail }
      WhyValidationsSuckIn96::Validation.new_subclass(:validates_rockingness, {}, validation)
    end

    should "have validates? return true if the validation passes" do
      validation = topic.new(true)
      validation.validates?
    end.equals(true)
    
    should "be passed when run and pass is called" do
      validation = topic.new(true)
      validation.validates?
      validation.passed?
    end
    
    should "have validates? return false if the validation fails" do
      validation = topic.new(false)
      validation.validates?
    end.equals(false)
    
    should "be failed when run and fail is called" do
      validation = topic.new(false)
      validation.validates?
      validation.failed?
    end
  end # an instance of a subclass with an actual validation definition
  
  context "an instance of a subclass with a validation definition that raises" do
    setup do
      validation = lambda { |val| raise "hell" }
      WhyValidationsSuckIn96::Validation.new_subclass(:validates_rockingness, {}, validation)
    end
    
    should "raise an exception when validating" do
      topic.new(Object.new).validates?
    end.raises(RuntimeError, "hell")
    
  end # an instance of a subclass with a validation definition that raises
end   # validation