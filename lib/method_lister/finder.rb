module MethodLister
  class Finder
    def ls(object)
      @results, @seen = Array.new, Hash.new
      scan :eigenclass, object, :singleton_methods
      search_class_hierarchy(object.class)
      @results
    end

    def grep(rx, object)
      ls(object).map do |result|
        result.narrow_to_methods_matching!(rx)
      end.select { |result| result.has_methods? }
    end

    def which(method, object)
      grep(/^#{Regexp.escape(method.to_s)}$/, object)
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

    def record_methods(object, lister_method)
      methods = object.send(lister_method, false).sort
      unless methods.empty?
        @results << FindResult.new(:object => object, :public => methods)
      end
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