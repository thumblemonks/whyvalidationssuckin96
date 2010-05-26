require 'teststrap'
require 'active_support'

context "validation_collection" do
  setup do
    @validation_options = { :is => 3 }
    @collection = WhyValidationsSuckIn96::ValidationCollection.new
    @collection << WhyValidationsSuckIn96::ValidatesLength.new(Object.new, { :attribute => :thing }.merge(@validation_options))
  end

  context "to_hash" do
    setup do
      @collection.to_hash
    end

    asserts("is a hash") { topic.is_a?(Hash) }
  end

  context "to_json" do
    setup do
      ActiveSupport::JSON.decode(@collection.to_json)
    end

    should "have keys for each attribute that is validated" do
      topic.keys
    end.equals(['thing'])

    should "not have a value that is the attribute name" do
      !topic['thing'].keys.include? 'thing'
    end

    should "have a message value that is the validation's message" do
      topic['thing']['message'] == @collection.first.message
    end

    should "have values of the validation options" do
      @validation_options.all? {|option,value| topic['thing'][option.to_s] == value }
    end

    context "provided a hash of options" do
      setup do
        @collection << WhyValidationsSuckIn96::ValidatesNumericality.new(Object.new, { :attribute => :other_thing })
        ActiveSupport::JSON.decode(@collection.to_json(:only => :thing))
      end

      should "respect those options when generating json" do
        topic.keys == ['thing']
      end
    end

    context "selecting a subset" do
      setup do
        @collection << WhyValidationsSuckIn96::ValidatesNumericality.new(Object.new, { :attribute => :other_thing })
        @collection.select { |v| v.attribute == :thing }
      end

      should "return a ValidationCollection" do
        topic.instance_of? WhyValidationsSuckIn96::ValidationCollection
      end
    end

    context "rejecting a subset" do
      setup do
        @collection << WhyValidationsSuckIn96::ValidatesNumericality.new(Object.new, { :attribute => :other_thing })
        @collection.reject { |v| v.attribute == :thing }
      end

      should "return a ValidationCollection" do
        topic.instance_of? WhyValidationsSuckIn96::ValidationCollection
      end
    end

  end
end
