require 'teststrap'
require 'rails/active_record_test_helper'

context "association validation" do
  has_association_validation = lambda do |klass,assoc|
    !klass.validation_collection.detect do |(validation_klass,opts)|
      validation_klass == WhyValidationsSuckIn96::ValidatesAssociated && opts[:attribute] == assoc && opts[:on] == :save
    end.nil?
  end
  
  context "against has_many" do
    context "with :validate set to true" do
      setup do
        Class.new(Book) do
          has_many :chapters, :validate => true
        end
      end
      
      should "set up an association validation" do
        has_association_validation[topic, :chapters]
      end
    end # with :validate set to true
    
    context "with :validate set to false" do
      setup do
        Class.new(Book) do
          has_many :chapters, :validate => false
        end
      end
      
      should "not set up an association validation" do
        has_association_validation[topic, :chapters]
      end.equals(false)
    end # with :validate set to false
  end   # against has_many
  
  context "against has_and_belongs_to_many" do
    context "with :validate set to true" do
      setup do
        Class.new(Genre) do
          has_and_belongs_to_many :books, :validate => true
        end
      end
      
      should "set up an association validation" do
        has_association_validation[topic, :books]
      end
    end # with :validate set to true
    
    context "with :validate set to false" do
      setup do
        Class.new(Genre) do
          has_and_belongs_to_many :books, :validate => false
        end
      end
      
      should "not set up an association validation" do
        has_association_validation[topic, :books]
      end.equals(false)
    end # with :validate set to false
  end   # against has_and_belongs_to_many
  
  context "against has_one" do
    context "with :validate set to true" do
      setup do
        Class.new(Book) do
          has_one :glossary, :validate => true
        end
      end
      
      should "set up an association validation" do
        has_association_validation[topic, :glossary]
      end
    end # with :validate set to true
    
    context "with :validate set to false" do
      setup do
        Class.new(Book) do
          has_one :glossary, :validate => false
        end
      end
      
      should "not set up an association validation" do
        has_association_validation[topic, :glossary]
      end.equals(false)
    end # with :validate set to false
  end   # against has_one
  
  context "against belongs_to" do
    context "with :validate set to true" do
      setup do
        Class.new(Chapter) do
          belongs_to :book, :validate => true
        end
      end
      
      should "set up an association validation" do
        has_association_validation[topic, :book]
      end
    end # with :validate set to true
    
    context "with :validate set to false" do
      setup do
        Class.new(Chapter) do
          belongs_to :book, :validate => false
        end
      end
      
      should "not set up an association validation" do
        has_association_validation[topic, :book]
      end.equals(false)
    end # with :validate set to false
  end   # against belongs_to
end     # association validation