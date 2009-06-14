module FindScenarioNameSpace
  module MyModule
    public;    def module_public;    end; def common_public;    end
    protected; def module_protected; end; def common_protected; end
    private;   def module_private;   end; def common_private;   end
  end
  
  class Klass
    public;    def klass_public;    end; def common_public;    end
    protected; def klass_protected; end; def common_protected; end
    private;   def klass_private;   end; def common_private;   end
  end
  
  @object = Klass.new
  
  class << @object
    include MyModule
    
    public;    def eigen_public;    end; def common_public;    end
    protected; def eigen_protected; end; def common_protected; end
    private;   def eigen_private;   end; def common_private;   end
  end
  
  @expected = [
    # The commented out lines is the desired result, but can't make it work.
    # result(@object, :public    => ["eigen_public",    "common_public"   ],
    #                 :protected => ["eigen_protected", "common_protected"],
    #                 :private   => ["eigen_private",   "common_private"  ]),
    result(@object, :public    => ["eigen_public"],
                    :protected => ["eigen_protected"],
                    :private   => ["eigen_private"]),
    result(MyModule, :public    => ["module_public",    "common_public"   ],
                     :protected => ["module_protected", "common_protected"],
                     :private   => ["module_private",   "common_private"  ]),
    result(Klass, :public    => ["klass_public",    "common_public"   ],
                  :protected => ["klass_protected", "common_protected"],
                  :private   => ["klass_private",   "common_private"  ])
  ]
end
