module Kernel
    def ls(obj=self, displayer=ColorLister.new, finder=MethodFinder.new)
        displayer.display( finder.find(obj) )
    end

    def grep(regex, obj=self, displayer=ColorLister.new, finder=MethodFinder.new)
        displayer.display( finder.grep(regex, obj) )
    end
end
