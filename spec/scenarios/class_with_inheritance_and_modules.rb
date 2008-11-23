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
         result(Klass, :public => ["method_from_class"]),
      result(MyModule, :public => ["method_from_module"]),
    result(SuperKlass, :public => ["method_from_superclass"])
  ]
end
