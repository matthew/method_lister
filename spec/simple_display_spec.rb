require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MethodLister::SimpleDisplay do
  describe "#display" do
    before do
      @results = [
        result(Object.new, :public => ["foo"]),
        result(Object, :public => ["bar"]),
        result(Kernel, :public => ["baz"]),
      ]
      
      @displayer = MethodLister::SimpleDisplay.new
    end
    
    it "attempts to write out the relevant information" do
      output = ""
      stub(@displayer).puts do |*args|
        output += args.map {|arg| arg.to_s}.join("") + "\n"
      end
      @displayer.display @results
      output.should =~ /Module Kernel.*baz.*Class Object.*bar.*Eigenclass.*foo/m
    end
  end
end
