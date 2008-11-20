require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require 'method_finder'

def undefined_constants(*constants)
  constants.each do |konst|
    Object.send(:remove_const, konst) if Object.const_defined?(konst)
  end
end

describe MethodFinder do
  before do
    undefined_constants :Klass, :SuperKlass, :MyModule, :OtherModule
    @finder = MethodFinder.new
  end
  
  describe "without class inheritance" do
    before do
      class Klass; def method_from_class; end; end
      @obj = Klass.new
    end
    
    it "finds the methods" do
      @finder.find(@obj)[0].should == {
        :methods => ["method_from_class"], 
        :object => Klass
      }
    end
    
    describe "with module mixin" do
      before do
        module MyModule; def method_from_module; end; end
        class Klass; include MyModule; end
      end
      
      it "finds the methods" do
        @finder.find(@obj)[0].should == {
          :methods => ["method_from_class"].sort, 
          :object => Klass
        }
        
        @finder.find(@obj)[1].should == {
          :methods => ["method_from_module"].sort, 
          :object => MyModule
        }
      end
    end
  end
  
  describe "with class inheritance" do
    before do
      class SuperKlass; def method_from_superclass; end; end
      class Klass < SuperKlass; def method_from_class; end; end
      @obj = Klass.new
    end
    
    it "finds the methods" do
      @finder.find(@obj)[0].should == {
        :methods => ["method_from_class"].sort, 
        :object => Klass
      }
      
      @finder.find(@obj)[1].should == {
        :methods => ["method_from_superclass"].sort, 
        :object => SuperKlass
      }
    end
    
    describe "with module mixin" do
      before do
        module MyModule; def method_from_module; end; end
        class Klass; include MyModule; end
      end
      
      it "finds the methods" do
        @finder.find(@obj)[0].should == {
          :methods => ["method_from_class"].sort,
          :object => Klass
        }
        
        @finder.find(@obj)[1].should == {
          :methods => ["method_from_module"].sort, 
          :object => MyModule
        }
        
        @finder.find(@obj)[2].should == {
          :methods => ["method_from_superclass"].sort, 
          :object => SuperKlass
        }        
      end
    end
  end
  
  describe "with eigenclass extensions" do
    before do
      class Klass; def method_from_class; end; end
      @obj = Klass.new
      class << @obj; def method_from_eigenclass; end; end
    end
    
    it "finds the methods" do
      @finder.find(@obj)[0].should == {
        :methods => ["method_from_eigenclass"].sort,
        :object => @obj
      }
      
      @finder.find(@obj)[1].should == {
        :methods => ["method_from_class"].sort, 
        :object => Klass
      }
    end
    
    describe "with module mixin" do
      before do
        module MyModule; def method_from_module; end; end
        class << @obj; include MyModule; end
      end
      
      it "finds the methods" do
        @finder.find(@obj)[0].should == {
          :methods => ["method_from_eigenclass"].sort,
          :object => @obj
        }
      
        @finder.find(@obj)[1].should == {
          :methods => ["method_from_module"].sort, 
          :object => MyModule
        }
        
        @finder.find(@obj)[2].should == {
          :methods => ["method_from_class"].sort, 
          :object => Klass
        }
      end
    end
  end
  
  describe "deep class hierarchy" do
    before do
      undefined_constants :K1, :K2, :K3, :K4, :K5
      class K1;      def method_k1; end; def common_method; end; end
      class K2 < K1; def method_k2; end; def common_method; end; end
      class K3 < K2; def method_k3; end; def common_method; end; end
      class K4 < K3; def method_k4; end; def common_method; end; end
      class K5 < K4; def method_k5; end; def common_method; end; end
      @obj = K5.new
    end
    
    it "finds the methods" do
      (1..5).each do |klass_num|
        @finder.find(@obj)[5 - klass_num].should == {
          :methods => ["method_k#{klass_num}", "common_method"].sort, 
          :object => Object.const_get("K#{klass_num}")
        }
      end
    end
    
    describe "with modules interspersed in the hierarchy" do
      before do
        undefined_constants :M1, :M2, :M3, :M4, :M5
        module M1; def method_m1; end; end
        module M2; def method_m2; end; end
        module M3; def method_m3; end; end
        module M4; def method_m4; end; end
        module M5; def method_m5; end; end
        class K1; include M1; end
        class K2; include M2; end
        class K3; include M3; end
        class K4; include M4; end
        class K5; include M5; end
      end
      
      xit "finds the methods" do
        (1..5).each do |klass_num|
          @finder.find(@obj)[5 - klass_num].should == {
            :methods => ["method_k#{klass_num}", "method_m#{klass_num}", "common_method"].sort, 
            :object => Object.const_get("K#{klass_num}")
          }
        end
      end
    end
  end
end