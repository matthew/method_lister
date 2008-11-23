module FindScenarioNameSpace
  module MyModule
    def method_from_module
    end
  end
  
  class SuperKlass
    def method_from_superclass
    end
  end
  
  class Klass < SuperKlass
    include MyModule
    
    def method_from_class
    end
  end
  
  @object = Klass.new
  @expected = [
         Klass, ["method_from_class"],
      MyModule, ["method_from_module"],
    SuperKlass, ["method_from_superclass"]
  ]
end