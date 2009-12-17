require 'teststrap'

context "validation_support" do
  context "when mixed into a class" do
    setup do
      Class.new { include WhyValidationsSuckIn96::ValidationSupport }
    end
    
    should "add a 'validation_collection' method" do
      topic
    end.respond_to(:validation_collection)
    
    should "add a 'setup_validations' method" do
      topic
    end.respond_to(:setup_validations)
    
    should "add a 'valid?' instance method" do
      topic.new
    end.respond_to(:valid?)
    
    should "add a 'failed_validations' instance method" do
      topic.new
    end.respond_to(:failed_validations)
    
    should "add a 'passed_validations' instance method" do
      topic.new
    end.respond_to(:passed_validations)
    
    should "add a 'all_validations' instance method" do
      topic.new
    end.respond_to(:all_validations)
  end # mixed into a class
  
  context "when mixed into a class and used to add a simple validation" do
    setup do
      Class.new do
        attr_accessor :title
        include WhyValidationsSuckIn96::ValidationSupport
        setup_validations do
          validate :title_is_present, :example => "the number song", :message => "title must be present" do |inst|
            pass if inst.title && !inst.title.empty?
            fail
          end
        end # setup_validations
      end   # Class.new
    end     # setup
    
    context "given an instance of the class" do
      setup { topic.new }
      
      should "have one entry for all validations" do
        topic.all_validations.size
      end.equals(1)
    
      should "have all the entries for all validations be validation instances" do
        topic.all_validations.all? { |validation| validation.kind_of?(WhyValidationsSuckIn96::Validation) }
      end
    
      should "not be valid without a title" do
        topic.title = nil
        !topic.valid?
      end
    
      should "be valid with a title" do
        topic.title = "building steam with a grain of salt"
        topic.valid?
      end
    
      should "have one failed validation without a title" do
        topic.title = nil
        topic.valid?
        topic.failed_validations.size
      end.equals(1)
    end # given an instance of the class
  end   # when mixed into a class and used to add a simple validation
end     # validation_support
