require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MethodLister::Finder do
  before do
    @finder = MethodLister::Finder.new
  end
  
  describe "#find" do
    it "should have more than one scenario" do
      all_find_scenarios.should_not be_empty
    end
    
    all_find_scenarios.each do |scenario|
      it "finds method according to scenario #{scenario.name}" do
        scenario.setup!
        @finder.ls(scenario.object).should list_methods(scenario.expected)
      end
    end
  end

  describe "auxillary methods" do
    before do
      @object = Object.new
    end
    
    describe "with results" do
      before do
        stub(@finder).ls(@object) do
          [
            result(@object, :public => ["bar", "foo", "foo2"]),
            result(Object,  :public => ["foo", "foo3", "qux"]),
            result(Kernel,  :public => ["baz"]),
          ]
        end
      end

      describe "#grep" do
        it "narrows down the find results based on the given regex" do
          @finder.grep(/foo/, @object).should == [
            result(@object, :public => ["foo", "foo2"]),
            result(Object,  :public => ["foo", "foo3"])
          ]
        end
      end
      
      describe "#which" do
        it "attempts to regex escape the method name passed in" do
          mock(Regexp).escape("foo").twice
          @finder.which("foo", @object)
          @finder.which(:foo, @object)
        end
        
        it "returns the classes and objects hold the method" do
          @finder.which("foo", @object).should == [
            result(@object, :public => ["foo"]),
            result(Object,  :public => ["foo"])
          ]
          
          @finder.which("foo3", @object).should == [
            result(Object, :public => ["foo3"])
          ]
        end
        
        it "works correctly with symbols" do
          @finder.which(:foo, @object).should == [
            result(@object, :public => ["foo"]),
            result(Object,  :public => ["foo"])
          ]
          
          @finder.which(:foo3, @object).should == [
            result(Object, :public => ["foo3"])
          ]
        end
      end
    end
    
    describe "without results" do
      before do
        stub(@finder).ls(@object) { Array.new }
      end

      describe "#grep" do
        it "returns the empty list if nothing can be found" do
          @finder.grep(/I_MATCH_NOTHING/, @object).should == []
        end
      end
      
      describe "#which" do
        it "returns the empty list if nothing can be found" do
          @finder.which("I_MATCH_NOTHING", @object).should == []
        end
      end
    end
    
    describe "with results containing method_missing" do
      before do
        stub(@finder).ls(@object) do
          [
            result(Array,  :public => ["sort1", "sort2"]),
            result(Object, :public => ["method_missing", "sort3"])
          ]
        end
      end
      
      describe "#grep" do
        it "returns method_missing its list of results if found" do
          @finder.grep(/I_MATCH_NOTHING/, @object).should == [
            result(Object, :public => ["method_missing"]),
          ]
        end
      end
      
      describe "#which" do
        it "returns method_missing its list of results if found" do
          @finder.which("I_MATCH_NOTHING", @object).should == [
            result(Object, :public => ["method_missing"]),
          ]
        end
      end
    end    
  end  
end
