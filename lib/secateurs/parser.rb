module Secateurs
  class Parser
    def initialize(format)
      @parser = build_parser(format)
    end

    def parse(path)
      @parser.call(path)
    end

    private

    def build_parser(format)
      case format
      when "json"
        ->(path) { JSON.parse(File.read(path)) }
      when "ruby"
        ->(path) { DSL.parse(path) }
      when "yaml"
        ->(path) { YAML.load_file(path) }
      else
        raise ArgumentError, "Invalid format `#{format}`."
      end
    end
  end
end
