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
    K5, ["common_method", "method_k5"],
    K4, ["common_method", "method_k4"],
    K3, ["common_method", "method_k3"],
    K2, ["common_method", "method_k2"],
    K1, ["common_method", "method_k1"]
  ]
end