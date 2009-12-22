require 'whyvalidationssuckin96/rails/active_record'
WhyValidationsSuckIn96::ActiveRecord.warn_on_deprecation = false

ActiveRecord::Base.establish_connection(:adapter  => "sqlite3", :database => ":memory:")
ActiveRecord::Schema.define(:version => 1) do
  create_table :musical_works do |t|
    t.string :name
  end
  
  create_table :visual_works do |t|
    t.string :name
    t.string :author
    t.string :type
  end
  
  create_table :books do |t|
    t.string     :name
    t.has_one    :glossary
    t.has_many   :chapters
  end
  
  create_table :glossaries do |t|
    t.belongs_to :book
  end
  
  create_table :chapters do |t|
    t.string :name
    t.belongs_to :book
  end
  
  create_table :genres do |t|
    t.string :name
  end
  
  create_table :books_genres, :id => false do |t|
    t.belongs_to :book
    t.belongs_to :genre
  end
end 

class Glossary < ActiveRecord::Base
end

class Book < ActiveRecord::Base
end

class Chapter < ActiveRecord::Base
end

class Genre < ActiveRecord::Base
end

class MusicalWork < ActiveRecord::Base
  attr_accessor :state, :callbacks_run, :validations_run 

  def after_initialize
    @callbacks_run = []
    @validations_run = []
  end
  
  setup_validations do
    validate :something_that_passes do
      pass if validatable.state == :pass
    end
    
    validate :something_that_fails do
      fail if validatable.state == :fail
    end
    
    validate :validation_that_runs_on_update, :on => :update do
      validatable.validations_run << :validation_that_runs_on_update
    end
    
    validate :validation_that_runs_on_create, :on => :create do
      validatable.validations_run << :validation_that_runs_on_create
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

class VisualWork < ActiveRecord::Base
  setup_validations do
    validates_presence_of :name
  end
end

class Photograph < VisualWork
  setup_validations do
    validates_uniqueness_of :author, :base_class_scope => false
  end
end

class Painting < VisualWork
  setup_validations do
    validates_uniqueness_of :author, :base_class_scope => true
  end
end

class Collage < VisualWork
  setup_validations do
    validates_uniqueness_of :name, :scope => :author
  end
end