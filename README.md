# WhyValidationsSuckIn96

## Description

WhyValidationsSuckIn96 is a library for adding validation support to objects. It aims to have a very minimal 'surface
area', API-wise, and to be as easily testable as possible. It has no external dependencies unless you wish to use the
ActiveRecord integration, in which case you clearly need ActiveRecord installed.

## Documentation

See 'doc/index.html' for details, or [check the GitHub Pages site for the project](http://thumblemonks.github.com/whyvalidationssuckin96).

## Install

gem install 'whyvalidationssuckin96'

## Basic Usage

Require 'whyvalidationssuckin96' and include the WhyValidationsSuckIn96::ValidationSupport module into your class:
    
    require 'whyvalidationssuckin96'
    
    class Song
      attr_accessor :title, :artist
      include WhyValidationsSuckIn96::ValidationSupport
    end

Define your validations or call pre-existing validation macros inside a validation setup block:

    require 'whyvalidationssuckin96'

    class Song
      attr_accessor :title, :artist, :year
      include WhyValidationsSuckIn96::ValidationSupport
      
      setup_validations do
        validate :no_eighties_crap do
          if %w[BonJovi Dokken].include?(validatable.artist)
            fail
          else
            pass
          end
        end
        
        validates_presence_of :title, :artist
        validates_numericality_of :year, :only_integer => true
      end
    end

Check instances of your class for validity and inspect the failed validations:

    song = Song.new
    song.valid?
    song.invalid?
    song.failed_validations
    song.passed_validations
    song.all_validations
    
Easily inspect and test for the presence of validations on your class:

    Song.validation_collection.detect do |(klass, opts)|
      klass == WhyValidationsSuckIn96::ValidatesPresence
    end
    
    Song.validation_collection.detect do |(klass, opts)|
      klass == WhyValidationsSuckIn96::ValidatesNumericality && opts[:only_integer]
    end
    
Create your own reusable and testable validations:

    require 'whyvalidationssuckin96/skippable_validation'
    require 'whyvalidationssuckin96/attribute_based_validation'

    class ValidatesPrimaryColour < WhyValidationsSuckIn96::Validation
      include WhyValidationsSuckIn96::SkippableValidation
      include WhyValidationsSuckIn96::AttributeBasedValidation
    
      DefaultOptions = {:message => "is not a valid color"}
      ValidColours = %w[red green blue]
      
      def validate
        super
        if ValidColours.include?(attribute_value)
          pass
        else
          fail
        end
      end
      
    end # ValidatesPrimaryColour

    WhyValidationsSuckIn96::ValidationBuilder.register_macro :validates_primary_colour_of, ValidatesPrimaryColour
  
## ActiveRecord Integration

WhyValidationsSuckIn96 features ActiveRecord support. The caveat is that it violently tears out the existing 
validation API so anything that uses that will break. The good news is that what it replaces the existing validation
code with works as expected with features such as callbacks and preventing saves to the database when objects are 
invalid. All the standard ActiveRecord validation macros are available, and most have the same API to use when
setting them up.

To use the ActiveRecord support:

    require 'whyvalidationssuckin96/rails/active_record'
    
Then you can define validations as expected in your model classes:

    class Song < ActiveRecord::Base
      setup_validations do
        validates_uniqueness_of :title, :scope => :artist
      end  
    end
    
## Contributing
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with Rakefile or VERSION.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request.

## Todo

* Investigate moving to a model where single instances of validations are created and passed the object to validate,
  rather than the per-object validation scheme right now which _may_ be a bottleneck.
  
## Copying

Copyright (c) 2009 gabrielg/thumblemonks. See LICENSE for details.
