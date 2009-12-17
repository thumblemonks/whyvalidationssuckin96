require 'teststrap'
require 'ostruct'

context "validation builder" do
  
  context "when defining multiple validations with the same name in the one validation definition" do
    setup do
      fake_validation_target = OpenStruct.new(:validation_collection => {})
      validation_block = lambda do
        validate(:we_are_clones) {}
        validate(:we_are_clones) {}
      end # validation_block
      WhyValidationsSuckIn96::ValidationBuilder.new(fake_validation_target, validation_block).create_validations!
      fake_validation_target
    end
    
    should "only have one validation in the collection on the target" do
      topic.validation_collection.size
    end.equals(1)
    
  end # when defining multiple validations with the same name in the one validation definition
  
  context "when defining multiple validations with the same name in more than one validation definition" do
    setup do
      fake_validation_target = OpenStruct.new(:validation_collection => {})
      validation_block = lambda do
        validate(:we_are_clones) {}
      end # validation_block
      WhyValidationsSuckIn96::ValidationBuilder.new(fake_validation_target, validation_block).create_validations!
      WhyValidationsSuckIn96::ValidationBuilder.new(fake_validation_target, validation_block).create_validations!      
      fake_validation_target
    end
    
    should "only have one validation in the collection on the target" do
      topic.validation_collection.size
    end.equals(1)
    
  end # when defining multiple validations with the same name in the one validation definition
end   # validation builder