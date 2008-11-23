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
    result(@object, :public => ["method_from_eigenclass"]),
    result(Klass, :public => ["method_from_class"]),
  ]
end
