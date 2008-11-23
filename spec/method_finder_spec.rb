require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MethodFinder do
  before do
    @finder = MethodFinder.new
  end
  
  describe "find scenarios" do
    all_find_scenarios.each do |scenario|
      it "finds method according to scenario #{scenario.name}" do
        scenario.setup!
        @finder.find(scenario.object).should list_methods(scenario.expected)
      end
    end
  end
end