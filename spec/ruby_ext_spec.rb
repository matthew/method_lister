require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "Method Lister Ruby Extensions" do
  describe Kernel do
    before do
      mock.instance_of(MethodLister::ColorDisplay).display(:mcguffin, anything) { nil }
      @finder_class_double = mock.instance_of(MethodLister::Finder)
      @object = Object.new
    end
    
    describe "#ls" do
      before do
        @finder_class_double.ls(@object) { :mcguffin }
      end
      
      it "works correctly with the ls command" do
        @object.ls
      end
      
      it "works correctly with the mls command" do
        @object.mls
      end
    end

    describe "#grep" do
      before do
        @rx = /object_id/
        @finder_class_double.grep(@rx, @object) { :mcguffin }
      end
      
      it "works correctly with the grep command" do
        @object.grep @rx
      end
      
      it "works correctly with the mgrep command" do
        @object.mgrep @rx
      end
    end
    
    describe "#which" do
      before do
        @method = :object_id
        @finder_class_double.which(@method, @object) { :mcguffin }
      end
      
      it "works correctly with the which command" do
        @object.which @method
      end
      
      it "works correctly with the mwhich command" do
        @object.mwhich @method
      end
    end
  end
end
