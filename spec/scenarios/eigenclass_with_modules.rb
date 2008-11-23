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
    @object,  ["method_from_eigenclass"],
    MyModule, ["method_from_module"],
    Klass,    ["method_from_class"],
  ]
end