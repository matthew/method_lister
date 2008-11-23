module MethodListerMatchers
  def list_methods(method_list)
    ListMethods.new(method_list)
  end
  
  class ListMethods
    def initialize(expected)
      @expected = expected
    end
  
    def matches?(target)
      @target = convert_target_to_canonical_form(target)
      @target == @expected
    end
  
    def failure_message
      <<-MESSAGE
      Expected: #{@expected.inspect}
           Got: #{@target.inspect}
      MESSAGE
    end
    
    def negative_failure_message
      "Did not expect these findings: #{@expected.inspect}"
    end
    
    private
    
    def convert_target_to_canonical_form(target)
      new_target = Array.new
      target.each do |finding|
        new_target << finding.object
        new_target << finding.methods(:all)
      end
      new_target.slice(0, @expected.length)
    end
  end
end