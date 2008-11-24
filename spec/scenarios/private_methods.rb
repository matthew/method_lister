module FindScenarioNameSpace
  
  class Klass
    private
    
    def private_method_from_class
    end
  end
  
  @object = Klass.new
  @expected = [
    result(Klass, :private => ["private_method_from_class"])
  ]
end
