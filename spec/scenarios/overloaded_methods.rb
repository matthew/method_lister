module FindScenarioNameSpace
  class K1;      
    def method_k1; end; 
    def common_method; end; 
  end
  
  class K2 < K1; 
    def method_k2; end; 
    def common_method; end; 
  end
  
  class K3 < K2; 
    def method_k3; end; 
    def common_method; end; 
  end
  
  class K4 < K3; 
    def method_k4; end; 
    def common_method; end; 
  end
  
  class K5 < K4; 
    def method_k5; end; 
    def common_method; end; 
  end
  
  @object = K5.new
  @expected = [
    result(K5, :public => ["common_method", "method_k5"]),
    result(K4, :public => ["common_method", "method_k4"]),
    result(K3, :public => ["common_method", "method_k3"]),
    result(K2, :public => ["common_method", "method_k2"]),
    result(K1, :public => ["common_method", "method_k1"])
  ]
end
