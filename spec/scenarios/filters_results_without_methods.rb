module FindScenarioNameSpace
  class UltraKlass
    def method_from_ultraclass
    end
  end
  
  class SuperKlass < UltraKlass
  end
  
  class Klass < SuperKlass
    def method_from_klass
    end
  end
  
  @object = Klass.new
  @expected = [
    result(Klass, :public => ["method_from_klass"]),
    result(UltraKlass, :public => ["method_from_ultraclass"]),
  ]
end
