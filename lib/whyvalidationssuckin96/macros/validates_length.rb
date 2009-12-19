require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  class ValidatesLength < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "does not meet the given length restrictions"}
    ValidOptions = [:is, :in, :minimum, :maximum]
    OptionIncompatibility = {
      :is => [:minimum, :maximum, :in],
      :in => [:minimum, :maximum, :is]
    }

    def initialize(validatable, options = {})
      super
      check_options(options)
    end
    
    def validate
      super
      all_valid = ValidOptions.all? do |opt_name|
        next(true) if options[opt_name].nil?
        send(:"validate_#{opt_name}")
      end
      all_valid ? pass : fail
    end

  private

    def validate_is
      options[:is] == attribute_value.size
    end
    
    def validate_in
      options[:in].include?(attribute_value.size)
    end
    
    def validate_minimum
      options[:minimum] <= attribute_value.size
    end
    
    def validate_maximum
      options[:maximum] >= attribute_value.size
    end
    
    def check_options(options_hash)
      OptionIncompatibility.each do |opt,incompat|
        next unless options_hash[opt]
        bad_opt = incompat.detect { |opt_name| options_hash.keys.include?(opt_name) }
        if bad_opt
          names = [opt.inspect.to_s, bad_opt.inspect.to_s].sort
          raise(ArgumentError, "Option #{names.first} can not be mixed with #{names.last}")
        end
      end
      raise(ArgumentError, "Length options must be given as :minimum, :maximum, :is, or :in") unless options_hash.keys.any? do |opt|
        ValidOptions.include?(opt)
      end
    end
    
  end # Validation

  ValidationBuilder.register_macro :validates_length_of, WhyValidationsSuckIn96::ValidatesLength
end   # WhyValidationsSuckIn96
