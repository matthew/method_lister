module FindScenarioNameSpace
  class Klass
    def method_from_class
    end
  end
  
  @object = Klass.new
  
  class << @object
    def method_from_eigenclass
    end
  end
  
  @expected = [
    @object, ["method_from_eigenclass"],
    Klass,   ["method_from_class"],
  ]
end