module MethodLister
  class Finder
    def find(object)
      @findings, @seen = Array.new, Hash.new
      scan :eigenclass, object, :singleton_methods
      search_class_hierarchy(object.class)
      @findings
    end

    def grep(rx, object)
      find(object).map do |record|
        record[:methods] = record[:methods].select do |method| 
          (method =~ rx) || (method == "method_missing")
        end
        record unless record[:methods].empty?
      end.compact
    end

    def which(method, object)
      find(object).select do |record|
        [method.to_s, "method_missing"].any? {|m| record[:methods].include?(m)}
      end.map {|record| record[:object]}
    end

    private

    def search_class_hierarchy(klass)
      while klass
        scan :class, klass, :instance_methods
        klass = klass.superclass
      end
    end

    def scan(obj_type, obj, lister_method)
      unless @seen.has_key? obj
        @seen[obj] = true
        record_methods obj, lister_method
        modules_for(obj_type, obj).each do |_module|
          scan :module, _module, :instance_methods
        end
      end
    end

    def record_methods(obj, lister_method)
      methods = obj.send(lister_method, false).sort
      @findings << {:object => obj, :methods => methods} unless methods.empty?
    end

    def modules_for(obj_type, obj)
      case obj_type
      when :module
        obj.included_modules
      when :class
        if obj.superclass
          obj.included_modules - obj.superclass.included_modules
        else
          obj.included_modules
        end
      when :eigenclass
        if eigenclass = get_eigenclass(obj)
          eigenclass.included_modules - obj.class.included_modules
        else
          []
        end
      end
    end

    def get_eigenclass(object)
      class << object; self; end
    rescue TypeError
      nil
    end
  end
end