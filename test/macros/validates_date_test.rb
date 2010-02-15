require 'teststrap'

context "validates date" do

  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods
  end.includes('validates_as_date')

  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesDate.new(Object.new, :attribute => :start_date)
    end

    should "have a message accessor with a default message" do
      topic.message
    end.equals("does not match the given date format or is not a valid date")
  end # with some default options

  context "validating an object" do

    should "fail if given attribute does not match the regular expression" do
      validation = WhyValidationsSuckIn96::ValidatesDate.new(OpenStruct.new(:start_date => "13-22-1969"), :attribute => :start_date)
      validation.validates?
    end.equals(false)

    should "fail if given attribute is not a valid date" do
      validation = WhyValidationsSuckIn96::ValidatesDate.new(OpenStruct.new(:start_date => "02-31-1969"), :attribute => :start_date)
      validation.validates?
    end.equals(false)

    should "pass if given attribute matches the regular expression" do
      validation = WhyValidationsSuckIn96::ValidatesDate.new(OpenStruct.new(:start_date => "4-20-1969"), :attribute => :start_date)
      validation.validates?
    end
  end   # validating an object
end     # validates format