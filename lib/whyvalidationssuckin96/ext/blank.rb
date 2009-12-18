class Object
  unless instance_methods.grep("blank?")
    def blank?
      respond_to?(:empty?) ? empty? : !self
    end
  end
end 

class String
  unless instance_methods.grep("blank?")
    def blank?
      self !~ /\S/
    end
  end
end 

class Numeric
  unless instance_methods.grep("blank?")
    def blank?
      false
    end
  end
end 
    
class TrueClass
  unless instance_methods.grep("blank?")
    def blank?
      false
    end
  end
end 
  
class FalseClass
  unless instance_methods.grep("blank?")
    def blank?
      true
    end
  end
end 
    
class NilClass
  unless instance_methods.grep("blank?")
    def blank?
      true
    end
  end
end 
      