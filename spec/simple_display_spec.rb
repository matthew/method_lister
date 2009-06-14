require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MethodLister::SimpleDisplay do
  describe "#display" do
    before do
      @results = [
        result(Object.new, :public => ["foo"], :private => ["secret"]),
        result(Array, :private => ["secret"]),
        result(Object, :public => ["bar"]),
        result(Kernel, :public => ["baz"]),
      ]
      
      @displayer = MethodLister::SimpleDisplay.new
      
      @output = ""
      stub(@displayer).puts do |*args|
        @output += args.map {|arg| arg.to_s}.join("") + "\n"
      end
    end
    
    it "attempts to write out the relevant information" do
      @displayer.display @results
      @output.should =~ /Module Kernel.*baz.*Class Object.*bar.*Eigenclass.*foo/m
    end
    
    it "does show private methods by default" do
      @displayer.display @results
      @output.should =~ /PRIVATE/
      @output.should =~ /Class Array/
    end
    
    it "shows only public methods if told to" do
      @displayer.display @results, true
      @output.should_not =~ /PRIVATE/
      @output.should_not =~ /Class Array/
    end
  end
end
