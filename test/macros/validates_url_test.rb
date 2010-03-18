require 'teststrap'

context "validates url" do
  
  should "add a validation macro" do
    WhyValidationsSuckIn96::ValidationBuilder.instance_methods.map {|im| im.to_s}
  end.includes('validates_as_url')
  
  context "with some default options" do
    setup do
      WhyValidationsSuckIn96::ValidatesUrl.new(Object.new, :attribute => :url)
    end
  
    should "have a message accessor with a default message" do
      topic.message
    end.equals("is not a valid URL")
    
    should "default to allowing http and https schemes" do
      topic.options[:schemes]
    end.same_elements(%w[http https])
  end # with some default options
  
  context "validating an object" do
    
    context "with default schemes" do
      validatable = OpenStruct.new(:url => "")
      
      setup do
        WhyValidationsSuckIn96::ValidatesUrl.new(validatable, :attribute => :url)
      end
      
      should "allow a url with a valid scheme specified" do
        validatable.url = "http://www.example.com"
        topic.validates?
      end
      
      should "disallow a url with an invalid scheme specified" do
        validatable.url = "ldap://www.example.com"
        topic.validates?
      end.equals(false)
      
      should "disallow an invalid url" do
        validatable.url = "http:!bad example"
        topic.validates?
      end.equals(false)
      
      should "not infer schemes" do
        validatable.url = "www.example.com"
        topic.validates?
      end.equals(false)
    end   # with default schemes
    
    context "with some manually specified schemes" do
      validatable = OpenStruct.new(:url => "")
      
      setup do
        WhyValidationsSuckIn96::ValidatesUrl.new(validatable, :attribute => :url, :schemes => %w[ldap mailto])
      end
      
      should "allow a valid ldap url with a scheme specified" do
        validatable.url = "ldap://ldap.example.com"
        topic.validates?
      end
      
      should "allow a valid mailto url with a scheme specified" do
        validatable.url = "mailto:gabe@example.com"
        topic.validates?
      end
      
      should "disallow a url with an invalid scheme specified" do
        validatable.url = "http://www.example.com"
        topic.validates?
      end.equals(false)
      
      should "disallow an invalid url" do
        validatable.url = "ldap:!bad example"
        topic.validates?
      end.equals(false)
      
      should "not infer schemes" do
        validatable.url = "ldap.example.com"
        topic.validates?
      end.equals(false)
    end   # with some manually specified schemes
  end     # validating an object
end       # validates url