require 'teststrap'
require 'active_support'

context "validation_collection" do
  context "to_json" do
    setup do
      @validation_options = { :is => 3 }
      @collection = WhyValidationsSuckIn96::ValidationCollection.new
      @collection << WhyValidationsSuckIn96::ValidatesLength.new(Object.new, { :attribute => :thing }.merge(@validation_options))
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
  end
end
