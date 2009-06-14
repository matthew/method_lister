module MethodLister
  class FindResult
    attr_reader :object
    VISIBILITIES = [:public, :protected, :private]
    
    def initialize(object, options={})
      @object = object
      @methods = Hash.new
      VISIBILITIES.each do |visibility|
        @methods[visibility] = options[visibility] || Array.new
      end
    end
    
    def methods(visibility)
      if visibility == :all
        VISIBILITIES.inject(Array.new) { |result, viz| result + methods(viz) }
      elsif VISIBILITIES.include? visibility
        @methods[visibility]
      else
        raise ArgumentError, "Unknown visibility #{visibility.inspect}"
      end.sort
    end
    
    def has_methods?(visibility=:all)
      !methods(visibility).empty?
    end
    
    def narrow_to_methods_matching!(rx)
      VISIBILITIES.each do |visibility|
        @methods[visibility] = @methods[visibility].select do |method| 
          method =~ rx || method == "method_missing"
        end
      end
      self
    end
    
    def ==(other)
      object.eql?(other.object) && 
      methods(:all).sort == other.methods(:all).sort
    end
    
    def inspect
      repr = "object=#{object.inspect}\n"
      VISIBILITIES.each do |visibility|
        repr += "#{visibility}=#{methods(visibility).sort.inspect}\n"
      end
      repr
    end
  end
end