require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MethodLister::Finder do
  before do
    @finder = MethodLister::Finder.new
  end
  
  describe "#find" do
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
            {:object => @object, :methods => ["foo", "foo2", "bar"].sort},
            {:object => Object, :methods => ["foo", "foo3", "qux"].sort},
            {:object => Kernel, :methods => ["baz"].sort},
          ]
        end
      end

      describe "#grep" do
        it "narrows down the find results based on the given regex" do
          @finder.grep(/foo/, @object).should == [
            {:object => @object, :methods => ["foo", "foo2"].sort},
            {:object => Object, :methods => ["foo", "foo3"].sort}
          ]
        end
      end
      
      describe "#which" do
        it "returns the classes and objects hold the method" do
          @finder.which("foo", @object).should == [
            {:object => @object, :methods => ["foo"].sort},
            {:object => Object, :methods => ["foo"].sort}
          ]
          
          @finder.which("foo3", @object).should == [
            {:object => Object, :methods => ["foo3"].sort}
          ]
        end
        
        it "works correctly with symbols" do
          @finder.which(:foo, @object).should == [
            {:object => @object, :methods => ["foo"].sort},
            {:object => Object, :methods => ["foo"].sort}
          ]
          
          @finder.which(:foo3, @object).should == [
            {:object => Object, :methods => ["foo3"].sort}
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
            {:object => Array, :methods => ["sort1", "sort2"].sort},
            {:object => Object, :methods => ["sort3", "method_missing"].sort}
          ]
        end
      end
      
      describe "#grep" do
        it "returns method_missing its list of results if found" do
          @finder.grep(/I_MATCH_NOTHING/, @object).should == [
            {:object => Object, :methods => ["method_missing"].sort},
          ]
        end
      end
      
      describe "#which" do
        it "returns method_missing its list of results if found" do
          @finder.which("I_MATCH_NOTHING", @object).should == [
            {:object => Object, :methods => ["method_missing"].sort},
          ]
        end
      end
    end    
  end  
end
