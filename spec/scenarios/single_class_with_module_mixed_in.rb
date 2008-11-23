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
       Klass, ["method_in_class"],
    MyModule, ["method_in_module"]
  ]
end
