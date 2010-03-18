require 'teststrap'

context "validates numericality" do

  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods.map {|im| im.to_s}
  end.includes('validates_numericality_of')

  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesNumericality.new(Object.new, :attribute => :number)
    end

    should "have a message accessor with a default message" do
      topic.message
    end.equals("is not a numerical value")
  end # with some default options

  context "validating an object" do

    context "with the default option of :only_integer being false" do
      validatable = OpenStruct.new(:number => 123)

      setup do
        WhyValidationsSuckIn96::ValidatesNumericality.new(validatable, :attribute => :number)
      end

      should "pass for an actual integer" do
        validatable.number = 30000
        topic.validates?
      end

      should "pass for a regular old integer string" do
        validatable.number = "123"
        topic.validates?
      end

      should "pass for a valid integer with spaces" do
        validatable.number = "123 456"
        topic.validates?
      end

      should "pass for a valid integer with commas" do
        validatable.number = "123,456"
        topic.validates?
      end

      should "pass for a valid integer with a positive sign" do
        validatable.number = "+1234"
        topic.validates?
      end

      should "pass for a valid integer with a negative sign" do
        validatable.number = "-1234"
        topic.validates?
      end

      should "fail for an integer with letters" do
        validatable.number = "a1234"
        topic.validates?
      end.equals(false)

      should "fail for an integer with other punctuation" do
        validatable.number = "!1234"
        topic.validates?
      end.equals(false)

      should "pass for an actual float" do
        validatable.number = 123.45
        topic.validates?
      end

      should "pass for a regular old float" do
        validatable.number = "123.456"
        topic.validates?
      end

      should "pass for a valid float with spaces" do
        validatable.number = "123 456.10"
        topic.validates?
      end

      should "pass for a valid float with commas" do
        validatable.number = "123,456.10"
        topic.validates?
      end

      should "pass for a valid float with a positive sign" do
        validatable.number = "+123456.10"
        topic.validates?
      end

      should "pass for a valid float with a negative sign" do
        validatable.number = "-123456.10"
        topic.validates?
      end

      should "fail for a float with letters other than the exponent" do
        validatable.number = "123z456.10"
        topic.validates?
      end.equals(false)

      should "fail for a float with other punctuation" do
        validatable.number = "$123456.10"
        topic.validates?
      end.equals(false)

    end # with the default option of :only_integer being false

    context "with the :only_integer option being true" do
      validatable = OpenStruct.new(:number => 123)

      setup do
        WhyValidationsSuckIn96::ValidatesNumericality.new(validatable, :attribute => :number, :only_integer => true)
      end

      should "not allow float values" do
        validatable.number = 123.456
        topic.validates?
      end.equals(false)

      should "allow integer values" do
        validatable.number = 123
        topic.validates?
      end

    end # with the :only_integer option being true
  end   # validating an object
end     # validates numericality