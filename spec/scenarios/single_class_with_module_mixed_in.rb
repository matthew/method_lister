module FindScenarioNameSpace
  module MyModule
    def method_in_module
    end
  end
  
  class Klass
    include MyModule
    
    def method_in_class
    end
  end

  @object = Klass.new
  @expected = [
       result(Klass, :public => ["method_in_class"]),
    result(MyModule, :public => ["method_in_module"])
  ]
end
