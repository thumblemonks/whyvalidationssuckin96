require 'active_record/base'
require 'active_record/callbacks'

module WhyValidationsSuckIn96    
  module ActiveRecord
    class << self
      attr_accessor :warn_on_deprecation
    end
    self.warn_on_deprecation = true
    
    RemovableInstanceMethods = %w[invalid? validate_on_create validate_on_update validate errors]
    RemovableClassMethods = %w[validate validate_on_create validate_on_update validates_format_of validates_each
                               validates_inclusion_of validates_size_of validates_confirmation_of validates_exclusion_of
                               validates_uniqueness_of validates_associated validates_acceptance_of
                               validates_numericality_of validates_presence_of validates_length_of]
    
    def self.included(klass_or_mod)
      remove_active_record_validation_related_methods_from(klass_or_mod)
      klass_or_mod.instance_eval do
        include WhyValidationsSuckIn96::ValidationSupport
        include WhyValidationsSuckIn96::ActiveRecord::InstanceMethods
        extend WhyValidationsSuckIn96::ActiveRecord::ClassMethods
      end
    end
    
  private
  
    # FIXME - holy mother of god is this a nasty method
    def self.remove_active_record_validation_related_methods_from(klass_or_mod)
      method_map = {klass_or_mod => RemovableInstanceMethods, (class<<klass_or_mod;self;end) => RemovableClassMethods}
      method_map.each do |context, removable_methods|
        context.instance_eval do 
          removable_methods.each do |removable_method|
            begin
              remove_method removable_method
            rescue => e
              undef_method removable_method
            end
          end # removable_methods.each
        end   # context.instance_eval
      end     # method_map.each
    end
    
    module ClassMethods
      
      # FIXME - this is a seedy hack and i blame the entire contents of active_record/autosave_association.rb
      # for it being necessary.
      def validate(*args)
        return false unless WhyValidationsSuckIn96::ActiveRecord.warn_on_deprecation
        callstack = caller
        warn(<<-EOW.gsub(/^\s{10}/, ""))
          This is a friendly message from WhyValidationsSuckIn96. #{self.inspect} called 'validate' which is a
          deprecated method. The arguments given were:
          
            #{args.inspect} - #{block_given? ? 'block given' : 'no block given'}
            
          and the caller was:
          
            #{callstack.first}
          
          If these warnings are coming from a call to 'add_autosave_association_callbacks', do not be alarmed, as
          WhyValidationsSuckIn96 has implemented its own versions of the necessary validation callbacks.
            
          These warnings can be silenced by setting 'WhyValidationsSuckIn96::ActiveRecord.warn_on_deprecation' to false.
          You will now be returned to your regularly scheduled programming.
        EOW
        false
      end
      
    end # ClassMethods
    
    module InstanceMethods    
      
      def self.included(klass_or_mod)
        klass_or_mod.module_eval do
          alias_method :valid_without_callbacks?, :valid_with_lifecycle_checking?
        end
      end

    private
    
      def validations_for_current_lifecycle
        validations_for_save + (new_record? ? validations_for_create : validations_for_update)
      end
      
      def valid_with_lifecycle_checking?
        validations_for_current_lifecycle.collect do |validation|
          validation.validates?
        end.all?
      end
      
      def validations_for_update
        all_validations.select do |validation|
          validation.options[:on] == :update
        end
      end
      
      def validations_for_create
        all_validations.select do |validation|
          validation.options[:on] == :create
        end
      end
      
      def validations_for_save
        all_validations.select do |validation|
          validation.options[:on].nil? || validation.options[:on] == :save
        end
      end
      
    end # InstanceMethods
  end   # ActiveRecord
end     # WhyValidationsSuckIn96

module ActiveRecord
  class RecordInvalid < ActiveRecordError
    attr_reader :record
    def initialize(record)
      @record = record
      super
    end
  end # RecordInvalid
end   # ActiveRecord

ActiveRecord::Base.instance_eval { include WhyValidationsSuckIn96::ActiveRecord }