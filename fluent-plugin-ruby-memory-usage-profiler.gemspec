# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-ruby-memory-usage-profiler"
  spec.version       = "0.0.2"
  spec.authors       = ["TAGOMORI Satoshi"]
  spec.email         = ["tagomoris@gmail.com"]
  spec.description   = %q{Collect memory usage profile information and emit it (or output on fluentd log)}
  spec.summary       = %q{Fluentd input plugin for memory usage profile of Ruby runtime and OS}
  spec.homepage      = "https://github.com/tagomoris/fluent-plugin-ruby-memory-usage-profiler"
  spec.license       = "APLv2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "fluentd"
  spec.add_runtime_dependency "ruby-memory-usage-profiler", ">= 0.0.2"
end
