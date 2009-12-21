require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'
require 'uri'

module WhyValidationsSuckIn96
  
  # Checks whether a given attribute is a valid URL
  #
  # @example Default usage
  #   setup_validations do
  #     validates_as_url :website
  #   end
  #
  # @example Specifying valid schemes instead of the defaults
  #   setup_validations do
  #     validates_as_url :website, :schemes => %w[ldap mailto]
  #   end
  class ValidatesUrl < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "is not a valid URL", :schemes => %w[http https]}
    
    def validate
      super
      uri = URI.parse(attribute_value)
      options[:schemes].include?(uri.scheme) ? pass : fail
    rescue URI::InvalidURIError => e
      fail
    end

  end # Validation

  ValidationBuilder.register_macro :validates_as_url, WhyValidationsSuckIn96::ValidatesUrl
end   # WhyValidationsSuckIn96