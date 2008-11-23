module Kernel
    def mls(displayer=ColorLister.new, finder=MethodFinder.new)
        displayer.display finder.find(self)
    end
    alias :ls :mls

    def mgrep(regex, displayer=ColorLister.new, finder=MethodFinder.new)
        displayer.display finder.grep(regex, self)
    end
    alias :grep :mgrep
    
    def mwhich(method, displayer=ColorLister.new, finder=MethodFinder.new)
      displayer.display finder.which(method, self)
    end
    alias :which :mwhich
end
