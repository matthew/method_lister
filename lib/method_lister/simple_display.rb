module MethodLister
  class SimpleDisplay
    def display(findings, show_public_only=false)
      findings.reverse.each do |result|
        list = method_list(result, show_public_only)
        if !list.empty?
          puts header(result)
          puts list
          puts seperator(result)
        end
      end
      nil
    end

    private

    def header(result)
      "========== #{location_description(result)} =========="
    end

    def method_list(result, show_public_only)
      FindResult::VISIBILITIES.map do |visibility|
        (visibility == :public || !show_public_only) ?
          method_set(result, visibility) : 
          nil
      end.compact.join("\n\n")
    end
    
    def method_set(result, visibility)
      if result.has_methods?(visibility)
        "#{visibility.to_s.upcase}: " + 
          result.methods(visibility).map {|method|
            process_method(result, method)
          }.join("  ")
      else
        nil
      end
    end
    
    def process_method(result, method)
      method
    end

    def seperator(result)
      ""
    end

    def location_description(result)
      object = result.object
      return "Class #{object}" if object.kind_of? Class
      return "Module #{object}" if object.kind_of? Module
      return "Eigenclass"
    end
  end
end