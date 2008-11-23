module FindScenarioNameSpace
  class Klass
    def method_in_class
    end
  end

  @object = Klass.new
  @expected = [
    result(Klass, :public => ["method_in_class"])
  ]
end
