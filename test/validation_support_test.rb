require 'teststrap'

context "validation_support" do

  context "when mixed into a class supporting callbacks" do
    setup do
      Class.new do
        attr_reader :callbacks_run

        def initialize
          @callbacks_run = []
        end

        def run_callbacks(callback_name)
          @callbacks_run << callback_name
        end

        include WhyValidationsSuckIn96::ValidationSupport
        setup_validations do
          validate(:foo) { pass }
        end
      end.new
    end

    should "run the before_validation callback when calling valid?" do
      topic.callbacks_run.clear
      topic.valid?
      topic.callbacks_run
    end.includes(:before_validation)

    should "run the after_validation callback when calling valid?" do
      topic.callbacks_run.clear
      topic.valid?
      topic.callbacks_run
    end.includes(:after_validation)

  end # when mixed into a class supporting callbacks

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

    should "add a 'invalid?' instance method" do
      topic.new
    end.respond_to(:invalid?)

    should "add a 'failed_validations' instance method" do
      topic.new
    end.respond_to(:failed_validations)

    should "add a 'passed_validations' instance method" do
      topic.new
    end.respond_to(:passed_validations)

    should "add a 'all_validations' instance method" do
      topic.new
    end.respond_to(:all_validations)

    should "have a ValidationCollection for all_validations" do
      topic.new.all_validations.instance_of?(WhyValidationsSuckIn96::ValidationCollection)
    end

    should "have an empty validation collection" do
      topic.validation_collection.size
    end.equals(0)

    should "be valid when no validations have been defined" do
      topic.new.valid?
    end

    should "not be invalid when no validations have been defined" do
      !topic.new.invalid?
    end
  end # mixed into a class

  context "when mixed into a class and used to add a simple validation" do
    setup do
      Class.new do
        attr_accessor :title
        include WhyValidationsSuckIn96::ValidationSupport
        setup_validations do
          validate :title_is_present, :example => "the number song", :message => "title must be present" do
            pass if validatable.title && !validatable.title.empty?
            fail
          end
        end # setup_validations
      end   # Class.new
    end     # setup

    should "have one validation in the validation_collection" do
      topic.validation_collection.size
    end.equals(1)

    should "be able to reflect on the validation and find its name" do
      topic.validation_collection.first.first.name
    end.equals(:title_is_present)

    should "be able to reflect on the validation and find its options" do
      topic.validation_collection.first.last
    end.equals(:example => "the number song", :message => "title must be present")

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

      should "have one passed validation with a title" do
        topic.title = "building steam with a grain of salt"
        topic.valid?
        topic.passed_validations.size
      end.equals(1)

      should "have one failed validation without a title" do
        topic.title = nil
        topic.valid?
        topic.failed_validations.size
      end.equals(1)
    end # given an instance of the class
  end   # when mixed into a class and used to add a simple validation

  context "when extending a class with existing validations and adding new validations" do
    parent_class = child_class = nil

    setup do
      parent_class = Class.new do
        attr_accessor :artist
        include WhyValidationsSuckIn96::ValidationSupport
        setup_validations do
          validate :artist_is_present, :example => "dj shadow", :message => "artist must be present" do
            pass if validatable.artist && !validatable.artist.empty?
            fail
          end
        end # setup_validations
      end   # parent_class

      child_class = Class.new(parent_class) do
        attr_accessor :title
        setup_validations do
          validate :title_is_present, :example => "the number song", :message => "title must be present" do
            pass if validatable.title && !validatable.title.empty?
            fail
          end
        end # setup_validations
      end   # child_class
    end     # setup

    should "have only one validation in the collection for the base class" do
      parent_class.validation_collection.size
    end.equals(1)

    should "have a validation for the artist in the base class" do
      parent_class.validation_collection.detect {|(validation, opts)| validation.name == :artist_is_present }
    end

    should "have two validations in the collection for the child class" do
      child_class.validation_collection.size
    end.equals(2)

    should "have a validation for the artist in the child class" do
      child_class.validation_collection.detect {|(validation, opts)| validation.name == :artist_is_present }
    end

    should "have a validation for the title in the child class" do
      child_class.validation_collection.detect {|(validation, opts)| validation.name == :title_is_present }
    end

  end   # when extending a class with existing validations

  context "when extending a class with existing validations and not adding new validations" do
    parent_class = child_class = nil

    setup do
      parent_class = Class.new do
        attr_accessor :artist
        include WhyValidationsSuckIn96::ValidationSupport
        setup_validations do
          validate :artist_is_present, :example => "dj shadow", :message => "artist must be present" do
            pass if validatable.artist && !validatable.artist.empty?
            fail
          end
        end # setup_validations
      end   # parent_class

      child_class = Class.new(parent_class)
    end     # setup

    should "have the parent class' validations by default" do
      child_class.validation_collection.size
    end.equals(1)

  end # when extending a class with existing validations and not adding new validations

  context "when calling setup_validations twice in a class" do
    setup do
      Class.new do
        include WhyValidationsSuckIn96::ValidationSupport
        setup_validations do
          validate(:first_validation) {}
        end
        setup_validations do
          validate(:second_validation) {}
        end
      end   # Class.new
    end     # setup

    should "add two validations to the class" do
      topic.validation_collection.size
    end.equals(2)

    should "have the first validation" do
      topic.validation_collection.detect { |(validation, opts)| validation.name == :first_validation }
    end

    should "have the second validation" do
      topic.validation_collection.detect { |(validation, opts)| validation.name == :second_validation }
    end

  end # when calling setup_validations twice in a class

  context "when asking for validations on a specific attribute" do
    setup do
      Class.new do
        include WhyValidationsSuckIn96::ValidationSupport
        setup_validations do
          validates_presence_of :foo
        end
      end   # Class.new
    end

    should "return validations on an instance" do
      topic.new.validations_for(:foo).size
    end

    should "return validations an empty array if no validations on attribute" do
      topic.new.validations_for(:bar).size
    end.equals(0)
  end

end   # validation_support
