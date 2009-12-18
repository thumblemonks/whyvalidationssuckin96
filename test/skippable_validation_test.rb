require 'teststrap'
require 'whyvalidationssuckin96/skippable_validation'

context "skippable validation mixin" do
  context "when mixed into a class" do
    
    setup do
      Class.new(WhyValidationsSuckIn96::Validation) do
        include WhyValidationsSuckIn96::SkippableValidation
        attr_accessor :skip_validation
        
        def validate
          super
          options[:should_pass] ? pass : fail
        end
      end # Class.new
    end   # setup
    
    context "when specifying an :if option" do
      context "as a block" do
        
        setup do
          topic.new(Object.new, :if => lambda { !skip_validation })
        end
        
        should "not have run if the block returns false" do
          topic.skip_validation = true
          topic.validates?
          topic.has_run?
        end.equals(false)

        should "have run if the block returns true" do
          topic.skip_validation = false
          topic.validates?
          topic.has_run?
        end
      end # as a block

      context "as a symbol" do
        validatable = nil
        
        setup do
          validatable = OpenStruct.new(:allow_validation => true)
          topic.new(validatable, :if => :allow_validation)
        end

        should "not have run if the method named by the symbol returns false" do
          validatable.allow_validation = false
          topic.validates?
          topic.has_run?
        end.equals(false)

        should "have run if the method named by the symbol returns true" do
          validatable.allow_validation = true
          topic.validates?
          topic.has_run?
        end      
      end # as a symbol
    end   # when specifying an :if option

    context "when specifying an :unless option" do
      context "as a block" do
        setup do
          topic.new(Object.new, :unless => lambda { skip_validation })
        end
        
        should "have run if the block returns false" do
          topic.skip_validation = false
          topic.validates?
          topic.has_run?
        end

        should "not have run if the block returns true" do
          topic.skip_validation = true
          topic.validates?
          topic.has_run?
        end.equals(false)
      end # as a block

      context "as a symbol" do
        validatable = nil
        
        setup do
          validatable = OpenStruct.new(:skip_validation => true)
          topic.new(validatable, :unless => :skip_validation)
        end
        
        should "have run if the method named by the symbol returns false" do
          validatable.skip_validation = false
          topic.validates?
          topic.has_run?
        end

        should "not have run if the method named by the symbol returns true" do
          validatable.skip_validation = true
          topic.validates?
          topic.has_run?
        end.equals(false)
      end # as a symbol
    end   # when specifying an :unless option
  end     # when mixed into a class
end       # skippable validation mixin