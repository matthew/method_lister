class SimpleLister
    def display(findings)
        findings.reverse.each do |record|
            write header(record)
            write method_list(record)
            write seperator(record)
        end
        nil
    end
    
    private

    def write(output)
        puts output
    end

    def header(record)
        description = location_description(record)
        "========== #{description} =========="
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
        return "self"
    end
end
