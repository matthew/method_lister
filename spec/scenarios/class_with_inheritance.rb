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
       Klass,   ["method_from_class"],
    SuperKlass, ["method_from_superclass"]
  ]
end