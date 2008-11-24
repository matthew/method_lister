module MethodLister
  class SimpleDisplay
    def display(findings)
      findings.reverse.each do |result|
        puts header(result)
        puts method_list(result)
        puts seperator(result)
      end
      nil
    end

    private

    def header(result)
      "========== #{location_description(result)} =========="
    end

    def method_list(result)
      result.methods(:all).join("  ")
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