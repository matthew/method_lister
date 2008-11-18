class AnsiEscape
    Colors = {
        :none => 0, :black_fg => 30, :red_fg => 31, :green_fg => 32,
        :yellow_fg => 33, :blue_fg => 34, :magenta_fg => 35, :cyan_fg => 36,
        :white_fg => 37, :black_bg => 40, :red_bg => 41, :green_bg => 42,
        :yellow_bg => 43, :blue_bg => 44, :magenta_bg => 45, :cyan_bg => 46,
        :white_bg => 47, :bold => 1, :underline => 4, :blink => 5, 
        :reverse => 7, :invisible => 8
    }

    def clear_screen
        print "\e[2J\e[H"
    end

    def color_string(string, *colors)
        color_code(*colors) + string + color_code(:none)
    end

    private

    def color_code(*colors)
        ansi_codes = colors.map {|c| Colors[c]}.compact.join(";")
        "\e[#{ansi_codes}m" unless ansi_codes.empty?
    end
end
