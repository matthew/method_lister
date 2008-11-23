module FindScenarioNameSpace
  module M1; def method_m1; end; end
  module M2; def method_m2; end; end
  module M3; def method_m3; end; end
  module M4; def method_m4; end; end
  module M5; def method_m5; end; end
  class K1;      include M1; def method_k1; end; end
  class K2 < K1; include M2; def method_k2; end; end
  class K3 < K2; include M3; def method_k3; end; end
  class K4 < K3; include M4; def method_k4; end; end
  class K5 < K4; include M5; def method_k5; end; end

  @object = K5.new
  @expected = [
    result(K5, :public => ["method_k5"]),
    result(M5, :public => ["method_m5"]),
    result(K4, :public => ["method_k4"]),
    result(M4, :public => ["method_m4"]),
    result(K3, :public => ["method_k3"]),
    result(M3, :public => ["method_m3"]),
    result(K2, :public => ["method_k2"]),
    result(M2, :public => ["method_m2"]),
    result(K1, :public => ["method_k1"]),
    result(M1, :public => ["method_m1"]),
  ]
end
