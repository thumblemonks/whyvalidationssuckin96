require 'whyvalidationssuckin96/skippable_validation'
require 'whyvalidationssuckin96/attribute_based_validation'

module WhyValidationsSuckIn96
  
  # Checks the validity of an attribute against a given set of sizes.
  #
  # @example Checking against an exact value
  #   setup_validations do
  #     validates_length_of :choices, :is => 4
  #   end
  #
  # @example Checking against a range
  #   setup_validations do
  #     validates_length_of :choices, :in => 1..10
  #   end
  #
  # @example Checking against a minimum value
  #   setup_validations do
  #     validates_length_of :choices, :minimum => 1
  #   end
  #
  # @example Checking against a maximum value
  #   setup_validations do
  #     validates_length_of :choices, :maximum => 10
  #   end
  #
  # @example Checking against a minimum and maximum value
  #   setup_validations do
  #     validates_length_of :choices, :minimum => 1, :maximum => 10
  #   end
  class ValidatesLength < Validation  
    include WhyValidationsSuckIn96::SkippableValidation
    include WhyValidationsSuckIn96::AttributeBasedValidation
    
    DefaultOptions = {:message => "does not meet the given length restrictions"}
    ValidOptions = [:is, :in, :minimum, :maximum]
    OptionIncompatibility = {
      :is => [:minimum, :maximum, :in],
      :in => [:minimum, :maximum, :is]
    }

    # @param  [Object] validatable          An object to be validated.
    # @param  [Hash]   options              The options to set up the validation with.
    # @option options  [#==]       :is      An exact value to check the validatable object's #size against.
    # @option options  [#include?] :in      A range to check the validatable object's #size against.
    # @option options  [#<=]       :minimum A minimum value to check the validatable object's size against.
    # @option options  [#>=]       :maximum A maximum value to check the validatable object's size against.
    def initialize(validatable, options = {})
      super
      check_options(options)
    end
    
    def validate
      super
      fail unless attribute_value.respond_to?(:size)
      all_valid = ValidOptions.collect do |opt_name|
        next(true) if options[opt_name].nil?
        send(:"validate_#{opt_name}")
      end.all?
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
