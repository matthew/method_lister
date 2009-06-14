module FindScenarioNameSpace
  module ModuleForClass
    public
    def method_from_module_public; end    
    def common_public; end

    protected
    def method_from_module_protected; end
    def common_protected; end

    private
    def method_from_module_private; end
    def common_private; end
  end

  module ModuleForEigenClass
    public
    def method_from_eigenmodule_public; end
    def common_public; end

    protected
    def method_from_eigenmodule_protected; end
    def common_protected; end

    private
    def method_from_eigenmodule_private; end
    def common_private; end
  end

  class SuperKlass
    public
    def method_from_superclass_public; end
    def common_public; end

    protected
    def method_from_superclass_protected; end
    def common_protected; end

    private
    def method_from_superclass_private; end
    def common_private; end
  end

  class Klass < SuperKlass
    include ModuleForClass
    
    public
    def method_from_class_public; end
    def common_public; end

    protected
    def method_from_class_protected; end
    def common_protected; end

    private
    def method_from_class_private; end
    def common_private; end    
  end

  original_object = Klass.new
  class << original_object
    include ModuleForEigenClass
    
    public
    def method_from_eigenclass_public; end
    def common_public; end    

    protected
    def method_from_eigenclass_protected; end
    def common_protected; end

    private
    def method_from_eigenclass_private; end
    def common_private; end    
  end
  
  @object = original_object.clone
  
  @expected = [
    result(@object, 
      # These commented out lines are the desired result
      # :public    => ["common_public", "method_from_eigenclass_public"],
      # :protected => ["common_protected", "method_from_eigenclass_protected"],
      # :private   => ["common_private", "method_from_eigenclass_private"]
      :public    => ["method_from_eigenclass_public"],
      :protected => ["method_from_eigenclass_protected"],
      :private   => ["method_from_eigenclass_private"]
    ),
    result(ModuleForEigenClass, 
      :public    => ["common_public", "method_from_eigenmodule_public"],
      :protected => ["common_protected", "method_from_eigenmodule_protected"],
      :private   => ["common_private", "method_from_eigenmodule_private"]
    ),
    result(Klass, 
      :public    => ["common_public", "method_from_class_public"],
      :protected => ["common_protected", "method_from_class_protected"],
      :private   => ["common_private", "method_from_class_private"]
    ),
    result(ModuleForClass, 
      :public    => ["common_public", "method_from_module_public"],
      :protected => ["common_protected", "method_from_module_protected"],
      :private   => ["common_private", "method_from_module_private"]
    ),
    result(SuperKlass, 
      :public    => ["common_public", "method_from_superclass_public"],
      :protected => ["common_protected", "method_from_superclass_protected"],
      :private   => ["common_private", "method_from_superclass_private"]
    )
  ]
end
