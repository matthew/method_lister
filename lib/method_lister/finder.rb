module MethodLister
  class Finder
    def find_all(object)
      @results, @seen = Array.new, Hash.new
      record_methods_for_eigenclass(object)
      search_class_hierarchy(object.class)
      @results
    end
    
    def ls(object)
      find_all(object).select { |results| results.has_methods? }
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
        scan :class, klass
        klass = klass.superclass
      end
    end
    
    def scan(type, klass_or_module)
      unless @seen.has_key? klass_or_module
        @seen[klass_or_module] = true
        record_methods_for klass_or_module
        scan_modules(type, klass_or_module)
      end
    end
    
    def scan_modules(type, klass_or_module)
      modules_for(type, klass_or_module).each do |a_module|
        scan :module, a_module
      end
    end
    
    def record_methods_for(klass_or_module)
      record_result(
        klass_or_module,
        :public    => klass_or_module.public_instance_methods(false),
        :protected => klass_or_module.protected_instance_methods(false),
        :private   => klass_or_module.private_instance_methods(false)
      )
    end
    
    def record_result(*args)
      @results << FindResult.new(*args) 
    end
    
    def modules_for(obj_type, klass_or_module)
      case obj_type
      when :module
        klass_or_module.included_modules
      when :class
        if superclass = klass_or_module.superclass
          klass_or_module.included_modules - superclass.included_modules
        else
          klass_or_module.included_modules
        end
      when :eigenclass
        eigenclass = get_eigenclass(klass_or_module)
        eigenclass.included_modules - klass_or_module.class.included_modules
      end
    end
    
    def record_methods_for_eigenclass(object)
      @seen[object] = true
      return unless eigenclass = get_eigenclass(object)

      # This complication arises because the methods used to do reflection on
      # eigenclasses will return methods from the object's class.  For public
      # and protected methods we can determine where the method came from, but
      # for private methods we have to do a heuristic guess.  c.f. scenario
      # "mixed_visibility_methods.rb"
      singleton_methods = object.singleton_methods(false)
      public_methods    = eigenclass.public_instance_methods(false)
      protected_methods = eigenclass.protected_instance_methods(false)
      private_methods   = eigenclass.private_instance_methods(false)
      ancestor_privates = eigenclass.ancestors.map do |ancestor|
        ancestor.private_instance_methods(false)
      end.flatten.uniq
      
      record_result(object, 
             :public    => singleton_methods & public_methods,
             :protected => singleton_methods & protected_methods,
             :private   => private_methods - ancestor_privates)
             
      scan_modules(:eigenclass, object)
    end
    
    def get_eigenclass(object)
      class << object; self; end
    rescue TypeError
      nil
    end
  end
end