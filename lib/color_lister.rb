class ColorLister < SimpleLister
    def initialize
        @ansi = AnsiEscape.new
    end

    def display(findings)
        @ansi.clear_screen
        super
    end

    private
    include ColoringMethods

    def method_list(record)
        record[:methods].map do |method| 
            color_method(record[:object], method)
        end.join(" ")
    end

    def color_method(source, method)
        coloring_methods.each do |coloring_method|
            colored_method = self.send(coloring_method, source, method)
            return colored_method if colored_method
        end
        method
    end

    def coloring_methods
        self.methods.select {|method| method =~ /^color_method_/}
    end

    def color(*args)
        @ansi.color_string(*args)
    end

    def location_description(record)
        color(super, :yellow, :bold)
    end
end
