module Kernel
  def mls(show_non_public=false, 
          displayer=MethodLister::ColorDisplay.new, 
          finder=MethodLister::Finder.new)
    displayer.display finder.ls(self), show_non_public
  end
  alias :ls :mls

  def mgrep(regex,
            show_non_public=false,
            displayer=MethodLister::ColorDisplay.new,
            finder=MethodLister::Finder.new)
    displayer.display finder.grep(regex, self), show_non_public
  end
  alias :grep :mgrep

  def mwhich(method,
             show_non_public=false,
             displayer=MethodLister::ColorDisplay.new, 
             finder=MethodLister::Finder.new)
    displayer.display finder.which(method, self), show_non_public
  end
  alias :which :mwhich
end
