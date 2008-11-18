module ColoringMethods
    def color_method_overloaded_from_kernel(source, method)
        if source != Kernel and Kernel.instance_methods.member? method
            color(method, :green_fg)
        end
    end

    def color_method_missing(source, method)
        color(method, :red_fg, :blink) if method == "method_missing"
    end

    def color_method_array_primative(source, method)
        exempt_sources = [Kernel, Fixnum, Hash, String, Enumerable, Array]
        unless exempt_sources.member? source
            primatives = %w{[] []= each <<}
            color(method, :magenta_fg) if primatives.member? method
        end
    end
end
