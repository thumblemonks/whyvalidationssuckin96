require 'whyvalidationssuckin96/validation_builder'
require 'whyvalidationssuckin96/validation_collection'

module WhyValidationsSuckIn96
  module ValidationSupport

    def self.included(klass_or_mod)
      klass_or_mod.module_eval do
        extend WhyValidationsSuckIn96::ValidationSupport::ClassMethods
        include WhyValidationsSuckIn96::ValidationSupport::InstanceMethods
      end
    end

    # Instance methods added to any class or module that mixes in ValidationSupport
    module InstanceMethods

      def self.included(klass)
        klass.module_eval do

        end
      end

      # Is this object invalid?
      # @return [true, false]
      def invalid?
        !valid?
      end

      def valid?
        self.class.run_with_generic_callbacks? ? valid_with_generic_callbacks? : valid_without_generic_callbacks?
      end

      # Is this object valid?
      # Also runs any callbacks if the class has callback support as defined by the
      # instance method run_callbacks being present.
      # @return [true, false]
      def valid_with_generic_callbacks?
        run_callbacks(:before_validation)
        valid_without_generic_callbacks?
      ensure
        run_callbacks(:after_validation)
      end

      # Is this object valid?
      # @return [true, false]
      def valid_without_generic_callbacks?
        all_validations.collect do |validation|
          # Checks manually because a 'nil' return is considered a skipped validation, not a failed one.
          (validation.validates? == false) ? false : true
        end.all?
      end

      # An array of instances of failed validations
      # @return [Array]
      def failed_validations
        all_validations.select { |validation| validation.failed? }
      end

      # An array of instances of passed validations
      # @return [Array]
      def passed_validations
        all_validations.select { |validation| validation.passed? }
      end

      # An array of instances of all validations for this object
      # @return [Array]
      def all_validations
        @all_validations ||= self.class.validation_collection.inject(ValidationCollection.new) do |vc, (v,opts)|
          vc << v.new(self, opts)
          vc
        end
      end

      def validations_for(attribute)
        all_validations.select do |validation|
          validation.respond_to?(:attribute) && validation.attribute == attribute.to_sym
        end
      end

    end # InstanceMethods

    module ClassMethods

      # If the class or module has a public 'run_callbacks' instance method, we run validations and fire
      # appropriate callbacks
      # @return [true, false]
      def run_with_generic_callbacks?
        if defined?(@run_with_generic_callbacks)
          @run_with_generic_callbacks
        else
          @run_with_generic_callbacks = !public_instance_methods.grep(/run_callbacks/).empty?
        end
      end

      # An array of arrays, the first element of each being the validation subclass that will be instantiated
      # when validation is performed, the last element being the options the validation will be instantiated
      # with.
      # @return [Array]
      def validation_collection
        @validation_collection ||= begin
          ancestor_with_validations = ancestors[1..-1].detect{|anc| anc.respond_to?(:validation_collection) }
          ancestor_with_validations ? ancestor_with_validations.validation_collection.dup : []
        end
      end

      # Sets up validations for the class or module this module has been mixed into
      def setup_validations(&definition_block)
        self.validation_collection ||= ancestors.detect{|anc| !anc.validation_collection.nil?}.validation_collection.dup
        builder = ValidationBuilder.new(self, definition_block)
        builder.create_validations!
      end

    end # ClassMethods
  end   # ValidationSupport
end     # WhyValidationsSuckIn96
