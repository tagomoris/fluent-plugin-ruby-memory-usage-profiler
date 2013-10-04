require "fluent/plugin/ruby_memory_profiler/version"

module Fluent
  class RubyMemoryUsageProfilerInput < Input
    Fluent::Plugin.register_input('ruby_memory_usage_profiler', self)
  end
end
