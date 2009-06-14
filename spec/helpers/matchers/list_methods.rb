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
      str, n = "", 0
      @expected.zip(@target).each do |expected, got|
        if expected != got
          str += <<-MESSAGE          
Expected[#{n}]: 
#{expected.inspect}
Got[#{n}]: 
#{got.inspect}             
          MESSAGE
        end
        n += 1
      end
      str
    end
    
    def negative_failure_message
      "Did not expect these findings: #{@expected.inspect}"
    end
    
    private
    
    def render_find_results(results)
      results.map {|result| "   #{result.inspect}" }.join("\n")
    end
  end
end