module MethodLister
  class FindResult
    VISIBILITIES = [:public, :protected, :private]
    
    def initialize(options={})
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
      end
    end
    
    def has_methods?(visibility=:all)
      !methods(visibility).empty?
    end
    
    def remove_methods_matching!(rx)
      VISIBILITIES.each do |visibility|
        @methods[visibility] = @methods[visibility].reject {|m| m =~ rx}
      end
      true
    end
  end
end