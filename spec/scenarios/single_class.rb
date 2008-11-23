module FindScenarioNameSpace
  class Klass
    def method_in_class
    end
  end

  @object = Klass.new
  @expected = [
    Klass, ["method_in_class"]
  ]
end
