require 'teststrap'

context "validates associated" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods.map {|im| im.to_s}
  end.includes('validates_associated')
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesAssociated.new(Object.new, :attribute => :things)
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("is invalid")
  end # with some default options
  
  context "validating a singular association" do
    associated = OpenStruct.new(:valid? => true)
    validatable = OpenStruct.new(:thing => associated)
    
    setup do
      WhyValidationsSuckIn96::ValidatesAssociated.new(validatable, :attribute => :thing)
    end
    
    should "be valid if associated object is valid" do
      def associated.valid?; true; end
      topic.validates?
    end
    
    should "be invalid if associated object is invalid" do
      def associated.valid?; false; end
      topic.validates?
    end.equals(false)
  end # validating a singular association
  
  context "validating a collection association" do
    associated = [OpenStruct.new(:valid? => true), OpenStruct.new(:valid? => false)]
    validatable = OpenStruct.new(:things => associated)
    
    setup do
      WhyValidationsSuckIn96::ValidatesAssociated.new(validatable, :attribute => :things)
    end
    
    should "be valid if all associated objects are valid" do
      associated.each do |assoc|
        def assoc.valid?; true; end
      end
      topic.validates?
    end
    
    should "be invalid if any associated objects are invalid" do
      associated.each do |assoc|
        def assoc.valid?; false; end
      end
      topic.validates?
    end.equals(false)
  end # validating a collection association
end   # validates associated