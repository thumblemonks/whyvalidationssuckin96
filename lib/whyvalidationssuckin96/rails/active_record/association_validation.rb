require 'active_record/autosave_association'

module WhyValidationsSuckIn96  
  module ActiveRecord
    module AssociationValidation
      
      def self.included(klass_or_mod)
        klass_or_mod.module_eval do
          extend ClassMethods
        end
      end
      
      module ClassMethods
        def self.extended(klass_or_mod)
          (class << klass_or_mod; self; end).instance_eval do 
            # FIXME - alias method chain my ass
            alias_method_chain :add_autosave_association_callbacks, :validation_hooks
          end
        end
        
        def add_autosave_association_callbacks_with_validation_hooks(reflection)
          add_autosave_association_callbacks_without_validation_hooks(reflection)
          setup_validations_for_association_reflection(reflection)
        end
        
      private
      
        def setup_validations_for_association_reflection(reflection)
          return false unless reflection.options[:validate] || reflection.options[:autosave]
          setup_validations { validates_associated reflection.name.to_sym, :on => :save }
        end
        
      end # ClassMethods
    end   # AssociationValidation
  end     # ActiveRecord
end       # WhyValidationsSuckIn96

ActiveRecord::Base.instance_eval { include WhyValidationsSuckIn96::ActiveRecord::AssociationValidation }