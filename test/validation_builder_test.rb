require 'teststrap'
require 'ostruct'

context "validation builder" do
  context "when defining some standard validations" do
    setup do
      fake_validation_target = OpenStruct.new(:validation_collection => [])
      validation_block = lambda do
        validate(:validates_whatever) {}
        validate(:validates_whenever) {}
      end
      WhyValidationsSuckIn96::ValidationBuilder.new(fake_validation_target, validation_block).create_validations!
      fake_validation_target
    end

    should "have a validates_whatever validation in the collection" do
      topic.validation_collection.detect { |(validation, opts)| validation.name == :validates_whatever }
    end
    
    should "have a validates_whenever validation in the collection" do
      topic.validation_collection.detect { |(validation, opts)| validation.name == :validates_whenever }
    end
    
    should "have Validation subclasses as the values for the validation_collection" do
      topic.validation_collection.all? {|(klass,opts)| klass.ancestors.include?(WhyValidationsSuckIn96::Validation)}
    end
  end # when defining some standard validations
  
  context "when defining multiple validations with the same name in the one validation definition" do
    setup do
      fake_validation_target = OpenStruct.new(:validation_collection => [])
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
      fake_validation_target = OpenStruct.new(:validation_collection => [])
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