require 'teststrap'

context "validates length" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods
  end.includes('validates_length_of')
  
  should "raise if an no options are given" do
    WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text)
  end.raises(ArgumentError, "Length options must be given as :minimum, :maximum, :is, or :in")

  should "have a message accessor with a default message" do
    WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :is => 3).message
  end.equals("does not meet the given length restrictions")
  
  should "not blow up with a nil attribute" do
    validation = WhyValidationsSuckIn96::ValidatesLength.new(OpenStruct.new(:text => nil), :attribute => :text, :is => 3)
    validation.validates?
  end.equals(false)
  
  context "when specifying the :is option" do
    should "not raise if solely :is is given" do
      WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :is => 3)
    end
    
    should "raise if :minimum is given" do
      WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :is => 3, :minimum => 4)
    end.raises(ArgumentError, "Option :is can not be mixed with :minimum")
    
    should "raise if :maximum is given" do
      WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :is => 3, :maximum => 2)
    end.raises(ArgumentError, "Option :is can not be mixed with :maximum")
    
    should "raise if :in is given" do
      WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :is => 3, :in => 5..10)
    end.raises(ArgumentError, "Option :in can not be mixed with :is")
    
    should "fail if the attribute length isn't exactly the given value" do
      validation = WhyValidationsSuckIn96::ValidatesLength.new(OpenStruct.new(:text => "testing"), :attribute => :text, :is => 4)
      validation.validates?
    end.equals(false)
    
    should "pass if the attribute length is exactly the given value" do
      validation = WhyValidationsSuckIn96::ValidatesLength.new(OpenStruct.new(:text => "test"), :attribute => :text, :is => 4)
      validation.validates?
    end
  end # when specifying the :is option
  
  context "when specifying the :in option" do

    should "not raise if solely :in is given" do
      WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :in => 1..10)
    end
    
    should "raise if :minimum is given" do
      WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :in => 1..10, :minimum => 4)
    end.raises(ArgumentError, "Option :in can not be mixed with :minimum")
    
    should "raise if :maximum is given" do
      WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :in => 1..10, :maximum => 4)
    end.raises(ArgumentError, "Option :in can not be mixed with :maximum")
    
    should "raise if :is is given" do
      WhyValidationsSuckIn96::ValidatesLength.new(Object.new, :attribute => :text, :in => 1..10, :is => 3)
    end.raises(ArgumentError, "Option :in can not be mixed with :is")

    context "using a two dot range" do
      validatable = OpenStruct.new(:text => "test")
      
      setup do
        WhyValidationsSuckIn96::ValidatesLength.new(validatable, :attribute => :text, :in => 2..10)
      end
      
      should "fail if the value is less than the beginning of the range" do
        validatable.text = "a"
        topic.validates?
      end.equals(false)
      
      should "fail if the value is more than the end of the range" do
        validatable.text = "a" * 12
        topic.validates?
      end.equals(false)
      
      should "pass if the value is exactly at the end of the range" do
        validatable.text = "a" * 10
        topic.validates?
      end
      
      should "pass if the value falls inside the range" do
        validatable.text = "test"
        topic.validates?
      end
    end # using a two dot range
    
    context "using a three dot range" do
      validatable = OpenStruct.new(:text => "test")
      
      setup do
        WhyValidationsSuckIn96::ValidatesLength.new(validatable, :attribute => :text, :in => 2...10)
      end
      
      should "fail if the value is less than the beginning of the range" do
        validatable.text = "a"
        topic.validates?
      end.equals(false)
      
      should "fail if the value is more than the end of the range" do
        validatable.text = "a" * 12
        topic.validates?
      end.equals(false)
      
      should "fail if the value is exactly at the end of the range" do
        validatable.text = "a" * 10
        topic.validates?
      end.equals(false)
      
      should "pass if the value falls inside the range" do
        validatable.text = "test"
        topic.validates?
      end
    end # using a three dot range
    
  end # when specifying the :in option

  context "when specifying the :minimum option" do
    validatable = OpenStruct.new(:text => "test")
    
    setup do
      WhyValidationsSuckIn96::ValidatesLength.new(validatable, :attribute => :text, :minimum => 4)
    end
    
    should "pass if the attribute length is above the minimum value" do
      validatable.text = "a" * 5
      topic.validates?
    end
    
    should "pass if the attribute length is equal to the minimum value" do
      validatable.text = "a" * 4
      topic.validates?
    end
    
    should "fail if the attribute length is less than the minimum value" do
      validatable.text = "a" * 2
      topic.validates?
    end.equals(false)
  end # when specifying the :minimum option
  
  context "when specifying the :maximum option" do
    validatable = OpenStruct.new(:text => "test")
    
    setup do
      WhyValidationsSuckIn96::ValidatesLength.new(validatable, :attribute => :text, :maximum => 10)
    end
    
    should "pass if the attribute length is below the maximum value" do
      validatable.text = "a" * 9
      topic.validates?
    end
    
    should "pass if the attribute length is equal to the maximum value" do
      validatable.text = "a" * 10
      topic.validates?
    end
    
    should "fail if the attribute length is more than the maximum value" do
      validatable.text = "a" * 15
      topic.validates?
    end.equals(false)
  end # when specifying the :maximum option
  
  context "when specifying the :minimum and :maximum options" do
    validatable = OpenStruct.new(:text => "test")
    
    setup do
      WhyValidationsSuckIn96::ValidatesLength.new(validatable, :attribute => :text, :minimum => 3, :maximum => 10)
    end
    
    should "pass if the attribute length falls into the min/max range" do
      validatable.text = "a" * 5
      topic.validates?
    end
  end # when specifying the :minimum and :maximum options
end     # validates length