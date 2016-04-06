require "secateurs/exporter/base"
require "secateurs/exporter/json_exporter"
require "secateurs/exporter/ruby_exporter"
require "secateurs/exporter/split_exporter"
require "secateurs/exporter/yaml_exporter"

module Secateurs
  module Exporter
    def self.build(options)
      if options[:split]
        return SplitExporter.new(options)
      end

      case options[:format]
      when "json"
        JSONExporter.new(options)
      when "ruby"
        RubyExporter.new(options)
      when "yaml"
        YAMLExporter.new(options)
      else
        raise ArgumentError, "Invalid format. #{options[:format]}"
      end
    end
  end
end
