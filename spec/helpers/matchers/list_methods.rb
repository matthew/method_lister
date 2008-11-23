module MethodListerMatchers
  def list_methods(method_list)
    ListMethods.new(method_list)
  end
  
  class ListMethods
    def initialize(expected)
      @expected = expected
    end
  
    def matches?(target)
      @target = target.slice(0, @expected.length)  # Trim extras from Rspec, Ruby, etc.
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
  end
end