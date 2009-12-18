require 'whyvalidationssuckin96/rails/active_record'

ActiveRecord::Base.establish_connection(:adapter  => "sqlite3", :database => ":memory:")
ActiveRecord::Schema.define(:version => 1) do
  create_table :musical_works do |t|
    t.string :name
  end
end 

class MusicalWork < ActiveRecord::Base
  attr_accessor :state, :callbacks_run, :validations_run 

  def after_initialize
    @callbacks_run = []
    @validations_run = []
  end
  
  setup_validations do
    validate :something_that_passes do |record|
      pass if record.state == :pass
    end
    
    validate :something_that_fails do |record|
      fail if record.state == :fail
    end
    
    validate :validation_that_runs_on_update, :on => :update do |record|
      record.validations_run << :validation_that_runs_on_update
    end
    
    validate :validation_that_runs_on_create, :on => :create do |record|
      record.validations_run << :validation_that_runs_on_create
    end
  end
  
  def before_validation_on_update
    callbacks_run << :before_validation_on_update
  end

  def before_validation
    callbacks_run << :before_validation
  end
  
  def before_validation_on_create
    callbacks_run << :before_validation_on_create
  end
  
  def after_validation_on_update
    callbacks_run << :after_validation_on_update
  end
  
  def after_validation
    callbacks_run << :after_validation
  end
  
  def after_validation_on_create
    callbacks_run << :after_validation_on_create
  end
  
end