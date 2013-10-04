module Fluent
  class RubyMemoryUsageProfilerInput < Input
    Fluent::Plugin.register_input('ruby_memory_usage_profiler', self)

    config_param :output_type, :string, :default => 'event' # 'event', 'log' or 'file'

    config_param :duration, :integer, :default => 1
    config_param :name, :string, :default => 'fluentd_memory'

    config_param :tag, :string, :default => 'memory_usage_profile'
    config_param :loglevel, :string, :default => 'info'
    config_param :path, :string, :default => nil # for 'output file'

    def initialize
      super
      require 'memory_usage_profiler'
    end

    def configure(conf)
      super

      @banner = MemoryUsageProfiler.banner_items

      case @output_type
      when 'event'
        @out = lambda{|result| Fluent::Engine.emit(@tag, Fluent::Engine.now, Hash[ [@banner, result].transpose ])}
      when 'log'
        @loglevel = @loglevel.to_sym
        @out = lambda{|result| $log.send(@loglevel, Hash[ [@banner, result].transpose ])}
      when 'file'
        raise Fluent::ConfigError, "'path' must be specified for 'output_type file'" unless @path
        @file = (@path == '-' ? STDOUT : open(@path, 'w+'))
        raise Fluent::ConfigError, "failed to open file '#{@path}' to write" unless @file
        @file.sync = true
        @file.puts @banner.join("\t")
        @out = lambda{|result| @file.puts result.join("\t")}
      else
        raise Fluent::ConfigError, "invalid output_type '#{@output_type}'"
      end
    end

    def start
      super
      @running = true
      @thread = Thread.new do
        begin
          count = 0
          while sleep(1)
            break unless @running

            count += 1
            next if count < @duration

            MemoryUsageProfiler.kick(@name) {|result|
              @out.call(result)
            }
            count = 0
          end
        rescue => e
          $log.error "Unexpected error in ruby_memory_usage_profiler", :error_class => e.class, :error => e
        end
      end
    end

    def stop
      @running = false
      @thread.join
    end
  end
end
