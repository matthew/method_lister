class ClassMonitor
    SingletonMap = {}

    def self.new(klass)
        SingletonMap[klass] ||= super
    end

    def initialize(klass)
        reset
        monitor_class(klass)
    end

    def reset(method=nil)
        method ? @calls.delete(method) : @calls = {}
    end

    def record(method, obj, rv, args)
        @calls[method] ||= []
        @calls[method] << {
            :args   => args.map {|arg| arg.class},
            :return => rv.class,
            :object => obj.class,
        }
    end

    def report(method=nil)
        methods = method ? [method] : @calls.keys
        methods.sort_by {|a,b| a.to_s <=> b.to_s}.each do |method|
            next unless @calls.has_key? method
            @calls[method].each do |record|
                signature = "#{method} :: "
                signature += [
                    record[:object],
                    record[:args],
                    record[:return]
                ].flatten.map {|c| c.to_s}.join(" -> ")
                puts signature
            end
        end
        nil
    end

    private

    def monitor_class(klass)
        raise "Can not monitor Proxy class" if klass == ClassMonitor::Proxy
        klass.instance_eval do
            alias original_new new
            def new(*args, &block)
                obj = original_new(*args, &block)
                ClassMonitor::Proxy.new(obj, ClassMonitor.new(self))
            end
        end
    end

    class Proxy
        instance_methods.each { |m| undef_method m unless m =~ /^__/ }

        def initialize(obj, monitor=ClassMonitor.new(obj.class))
            @obj = obj
            @monitor = monitor
        end

        def method_missing(method, *args, &block)
            rv = @obj.__send__(method, *args, &block)
            @monitor.record(method, @obj, rv, args)
            return rv
        end
    end
end
