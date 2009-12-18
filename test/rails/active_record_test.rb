require 'teststrap'
require 'rails/active_record_test_helper'

context "active record integration" do
  
  should "automatically be mixed into the records of the active variety" do
    ActiveRecord::Base
  end.respond_to(:validation_collection)
  
  context "given an example class, 'MusicalWork'" do
    setup { MusicalWork }
    
    should "have four validations in the collection" do
      topic.validation_collection.size
    end.equals(4)
    
    context "an instance testing basic validation functionality" do
      setup { topic.new }
      
      should "have three passes when the 'state' attribute is nil" do
        topic.state = nil
        topic.valid?
        topic.passed_validations.size
      end.equals(3)
      
      should "have one fail when the 'state' attribute is :fail" do
        topic.state = :fail
        topic.valid?
        topic.failed_validations.size
      end.equals(1)

      should "have two passes when the 'state' attribute is :fail" do
        topic.state = :fail
        topic.valid?
        topic.passed_validations.size
      end.equals(2)
      
      should "not be allowed to be saved in an invalid state" do
        topic.state = :fail
        topic.save
      end.equals(false)
      
      should "not respond to the 'errors' method" do
        topic.respond_to?(:errors)
      end.equals(false)
      
    end # an instance testing basic validation functionality

    context "an instance testing validation :on specification" do
      context "on create" do
        setup do
          instance = topic.new
          instance.save
          instance.validations_run
        end
        
        should "not have run the validation specified for :update" do
          topic.include?(:validation_that_runs_on_update)
        end.equals(false)
        
        should "have run the validation specified for :create" do
          topic
        end.includes(:validation_that_runs_on_create)
      end # on create
      
      context "on update" do
        setup do
          instance = topic.new
          instance.save
          raise "Whoa there. Topic needs to be a saved record." if instance.new_record?
          instance.validations_run.clear
          instance.save
          instance.validations_run
        end
        
        should "have run the validation specified for :update" do
          topic
        end.includes(:validation_that_runs_on_update)
        
        should "not have run the validation specified for :create" do
          topic.include?(:validation_that_runs_on_create)
        end.equals(false)
      end # on update
    end   # an instance testing validation :on specification
    
    context "an instance testing callback functionality" do
      
      context "on create" do
        setup do
          instance = topic.new
          instance.state = :fail
          instance.save
          instance.callbacks_run
        end
        
        should "have run the before_validation callback" do
          topic
        end.includes(:before_validation)
        
        should "have run the before_validation_on_create callback" do
          topic
        end.includes(:before_validation_on_create)
        
        should "not have run the before_validation_on_update callback" do
          topic.include?(:before_validation_on_update)
        end.equals(false)
        
        should "have run the after_validation callback" do
          topic
        end.includes(:after_validation)
        
        should "have run the after_validation_on_create callback" do
          topic
        end.includes(:after_validation_on_create)
        
        should "not have run the after_validation_on_update callback" do
          topic.include?(:after_validation_on_update)
        end.equals(false)
        
      end # on create
      
      context "on update" do
        setup do
          instance = topic.new
          instance.state = nil
          instance.save
          raise "Whoa there. Topic needs to be a saved record." if instance.new_record?
          instance.callbacks_run.clear
          instance.save
          instance.callbacks_run
        end
        
        should "have run the before_validation callback" do
          topic
        end.includes(:before_validation)
        
        should "not have run the before_validation_on_create callback" do
          topic.include?(:before_validation_on_create)
        end.equals(false)
        
        should "not have run the before_validation_on_update callback" do
          topic
        end.includes(:before_validation_on_update)
        
        should "have run the after_validation callback" do
          topic
        end.includes(:after_validation)
        
        should "have run the after_validation_on_create callback" do
          topic.include?(:after_validation_on_create)
        end.equals(false)
        
        should "not have run the after_validation_on_update callback" do
          topic
        end.includes(:after_validation_on_update)
        
      end # on create

    end   # an instance testing callback functionality
  end     # given an example class, 'MusicalWork'
end       # active record integration
