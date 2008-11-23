module Kernel
  def mls(displayer=MethodLister::ColorDisplay.new, finder=MethodLister::Finder.new)
    displayer.display finder.find(self)
  end
  alias :ls :mls

  def mgrep(regex, displayer=MethodLister::ColorDisplay.new, finder=MethodLister::Finder.new)
    displayer.display finder.grep(regex, self)
  end
  alias :grep :mgrep

  def mwhich(method, displayer=MethodLister::ColorDisplay.new, finder=MethodLister::Finder.new)
    displayer.display finder.which(method, self)
  end
  alias :which :mwhich
end
