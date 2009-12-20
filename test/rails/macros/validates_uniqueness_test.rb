require 'teststrap'
require 'rails/active_record_test_helper'

context "validates uniqueness" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods
  end.includes('validates_uniqueness_of')
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesUniqueness.new(Object.new, :attribute => :username)
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("has already been taken")
    
    should "default to being case insensitive" do
      topic.options[:case_sensitive]
    end.equals(false)
    
    should "default :base_class_scope to true" do
      topic.options[:base_class_scope]
    end.equals(true)
  end # with some default options
  
  context "validating an object" do
    
    context "with default options" do
      setup do
        Class.new(VisualWork) do
          setup_validations do
            validates_uniqueness_of :name
          end
        end # VisualWork
      end   # setup do
      
      should "mark the second object with the same name as invalid" do
        work = topic.new(:name => "example")
        work.save!
        other_work = topic.new(:name => "example")
        !other_work.valid? && other_work.failed_validations.detect do |fv|
          fv.kind_of?(WhyValidationsSuckIn96::ValidatesUniqueness) && fv.attribute == :name
        end
      end

      should "allow two objects with different names" do
        work = topic.new(:name => "example one")
        work.save!
        other = topic.new(:name => "example two")
        other.valid?
      end
      
      should "not care about case sensitivity by default" do
        work = topic.new(:name => "cAsE SeNsItiViTy")
        work.save!
        other_work = topic.new(:name => "case sensitivity")
        !other_work.valid? && other_work.failed_validations.detect do |fv|
          fv.kind_of?(WhyValidationsSuckIn96::ValidatesUniqueness) && fv.attribute == :name
        end
      end
      
      should "allow the one object to be saved twice and not violate the constraint" do
        work = topic.new(:name => "screenshot")
        work.save
        work.author = "gabe"
        work.save
      end
    end # with default options
    
    context "specifying case sensitivity" do
      setup do
        Class.new(VisualWork) do
          setup_validations do
            validates_uniqueness_of :name, :case_sensitive => true
          end
        end # VisualWork
      end   # setup do
      
      should "allow objects with the same name and different case to be valid" do
        work = topic.create!(:name => "CASE SENSITIVE IS TRUE")
        other_work = topic.new(:name => "case sensitive is true")
        other_work.valid?
      end
      
      should "mark the second object with the name in the same case as invalid" do
        work = topic.create(:name => "SO WHAT")
        other_work = topic.new(:name => "SO WHAT")
        !other_work.valid? && other_work.failed_validations.detect do |fv|
          fv.kind_of?(WhyValidationsSuckIn96::ValidatesUniqueness) && fv.attribute == :name
        end
      end
    end # specifying case sensitivity
    
    context "specifying base class scope" do
      context "as false" do
        should "allow records to be created in different subclasses that violate the uniqueness" do
          Painting.create!(:name => "painting one", :author => "humbug")
          Photograph.new(:name => "photo one", :author => "humbug").valid?
        end 
        
        should "not allow records to be created in the same class that violate the uniqueness" do
          Photograph.create!(:name => "photo one", :author => "gus")
          photo = Photograph.new(:name => "photo two", :author => "gus")
          !photo.valid? && photo.failed_validations.detect do |fv|
            fv.kind_of?(WhyValidationsSuckIn96::ValidatesUniqueness) && fv.attribute == :author
          end
        end
      end # as false
      
      context "as true" do
        should "not allow records to be created that violate a uniqueness constraint based on the base class" do
          VisualWork.create!(:name => "mspaint", :author => "dan")
          work = Painting.new(:name => "the treachery of images", :author => "dan")
          !work.valid? && work.failed_validations.detect do |fv|
            fv.kind_of?(WhyValidationsSuckIn96::ValidatesUniqueness) && fv.attribute == :author
          end
        end
        
        should "allow records to be created that don't violate the uniqueness constraint" do
          VisualWork.create!(:name => "photoshop", :author => "alex")
          Painting.create!(:name => "paintshop", :author => "evan")
        end
      end # as true
    end   # specifying base class scope
    
    context "specifying scope options" do
      should "pass when uniqueness is valid against the given scope column" do
        Collage.create!(:name => "wired snippets", :author => "dan")
        work = Collage.new(:name => "wired snippets", :author => "gabe")
        work.valid?
      end
      
      should "fail when uniqueness is invalid against the given scope column" do
        Collage.create!(:name => "rolling stone snippets", :author => "gabe")
        work = Collage.new(:name => "rolling stone snippets", :author => "gabe")
        !work.valid? && work.failed_validations.detect do |fv|
          fv.kind_of?(WhyValidationsSuckIn96::ValidatesUniqueness) && fv.attribute == :name
        end
      end
    end # specifying scope options
    
    context "when using with_scope" do
      should "basically just ignore with_scope" do
        Painting.create!(:author => "fred", :name => "bbzzzt")
        Painting.send(:with_scope, :find => {:conditions => {:author => "fred"}}) do
          Painting.create!(:author => "myles", :name => "bitchesbrew")
        end
      end
    end # when using with_scope
  end   # validating an object
end     # validates uniqueness