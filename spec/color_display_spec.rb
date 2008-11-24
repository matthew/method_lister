require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MethodLister::ColorDisplay do
  describe "#display" do
    before do
      @results = [
        result(Object.new, :public => ["foo"]),
        result(Array,  :public => ["bar"] + Array.public_instance_methods(false)),
        result(Kernel, :public => ["baz"] + Kernel.public_instance_methods(false)),
      ]
      
      @displayer = MethodLister::ColorDisplay.new
      
      @output = ""
      stub(@displayer).puts do |*args|
        @output += args.map {|arg| arg.to_s}.join("") + "\n"
      end
    end
    
    it "attempts to write out the relevant information" do
      @displayer.display @results
      @output.should =~ /Module Kernel.*.*Class Array.*bar.*Eigenclass.*foo/m
    end
    
    it "does not add ANSI codes if output is not a tty" do
      mock(@displayer).output_is_to_tty? { false }.times(any_times)
      @displayer.display @results
      @output.should_not =~ /\e\[0m;/m
    end
    
    it "does add ANSI codes if output is a tty" do
      mock(@displayer).output_is_to_tty? { true }.times(any_times)
      @displayer.display @results
      @output.should =~ /\e\[0m/m
    end
  end
end
