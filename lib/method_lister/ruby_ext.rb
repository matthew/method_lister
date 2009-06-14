module Kernel
  def mls(show_public_only=false, 
          displayer=MethodLister::ColorDisplay.new, 
          finder=MethodLister::Finder.new)
    displayer.display finder.ls(self), show_public_only
  end
  alias :ls :mls

  def mgrep(regex,
            show_public_only=false,
            displayer=MethodLister::ColorDisplay.new,
            finder=MethodLister::Finder.new)
    displayer.display finder.grep(regex, self), show_public_only
  end
  alias :grep :mgrep

  def mwhich(method,
             show_public_only=false,
             displayer=MethodLister::ColorDisplay.new, 
             finder=MethodLister::Finder.new)
    displayer.display finder.which(method, self), show_public_only
  end
  alias :which :mwhich
end
