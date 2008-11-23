module FindScenarioNameSpace
  class SuperKlass
    def method_from_superclass
    end
  end
  
  class Klass < SuperKlass
    def method_from_class
    end
  end
  
  @object = Klass.new
  @expected = [
       result(Klass, :public => ["method_from_class"]),
    result(SuperKlass, :public => ["method_from_superclass"])
  ]
end
