module MethodLister
  class SimpleDisplay
    def display(findings)
      findings.reverse.each do |record|
        puts header(record)
        puts method_list(record)
        puts seperator(record)
      end
      nil
    end

    private

    def header(record)
      "========== #{location_description(record)} =========="
    end

    def method_list(record)
      record[:methods].join("  ")
    end

    def seperator(record)
      ""
    end

    def location_description(record)
      obj = record[:object]
      return "Class #{obj}" if obj.kind_of? Class
      return "Module #{obj}" if obj.kind_of? Module
      return "Eigenclass"
    end
  end
end