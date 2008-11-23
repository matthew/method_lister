module FindScenarioNameSpace
  module MyModule
    def method_from_module
    end
  end
  
  class Klass
    def method_from_class
    end
  end
  
  @object = Klass.new
  
  class << @object
    include MyModule
    
    def method_from_eigenclass
    end
  end
  
  @expected = [
    result(@object, :public => ["method_from_eigenclass"]),
    result(MyModule, :public => ["method_from_module"]),
    result(Klass, :public => ["method_from_class"]),
  ]
end
