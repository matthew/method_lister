module MethodLister
  class ColorDisplay < SimpleDisplay
    def initialize
      @ansi = AnsiEscape.new
    end

    private

    def location_description(result)
      color(super, :yellow_fg, :bold)
    end

    def color_method_overloaded_from_kernel(source, method)
      if source != Kernel and Kernel.instance_methods.member? method
        color(method, :green_fg)
      end
    end

    def color_method_missing(source, method)
      color(method, :red_fg) if method == "method_missing"
    end

    def color_method_array_primative(source, method)
      exempt_sources = [Kernel, Fixnum, Hash, String, Enumerable, Array]
      unless exempt_sources.member? source
        primatives = %w{[] []= each <<}
        color(method, :magenta_fg) if primatives.member? method
      end
    end

    def process_method(result, method)
      color_method(result.object, method)
    end

    def color_method(source, method)
      coloring_methods.each do |coloring_method|
        colored_method = self.send(coloring_method, source, method)
        return colored_method if colored_method
      end
      method
    end

    def coloring_methods
      private_methods.select {|method| method =~ /^color_method_/}
    end

    def color(string, *colors)
      output_is_to_tty? ? @ansi.color_string(string, *colors) : string
    end

    def output_is_to_tty?
      $stdout.tty?
    end
  end

  class AnsiEscape
    Colors = {
      :none => 0, :black_fg => 30, :red_fg => 31, :green_fg => 32,
      :yellow_fg => 33, :blue_fg => 34, :magenta_fg => 35, :cyan_fg => 36,
      :white_fg => 37, :black_bg => 40, :red_bg => 41, :green_bg => 42,
      :yellow_bg => 43, :blue_bg => 44, :magenta_bg => 45, :cyan_bg => 46,
      :white_bg => 47, :bold => 1, :underline => 4, :blink => 5, 
      :reverse => 7, :invisible => 8
    }

    def color_string(string, *colors)
      color_code(*colors) + string + color_code(:none)
    end

    private

    def color_code(*colors)
      ansi_codes = colors.map {|c| Colors[c]}.compact.join(";")
      "\e[#{ansi_codes}m" unless ansi_codes.empty?
    end
  end
end