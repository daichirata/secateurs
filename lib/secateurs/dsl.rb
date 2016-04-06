require "secateurs/dsl/converter"
require "secateurs/dsl/template_builder"

module Secateurs
  class DSL
    DEFAULT = {
      "order" => 0,
      "settings" => {},
      "mappings" => {},
      "aliases" => {}
    }

    INDENT = 2

    def self.parse(path)
      self.new(path).parse
    end

    def initialize(path)
      @path = File.expand_path(path)
      @templates = {}
      @indent = -INDENT
    end

    def parse
      include_template(@path)

      @templates
    end

    private

    def define_template(name, &block)
      builder = TemplateBuilder.new do |b|
        b.instance_eval(&block)
      end

      @templates[name] = DEFAULT.merge(builder.attributes!)
    end

    def include_template(path)
      expanded_path = File.expand_path(path, File.dirname(@path))
      expanded_path += '.rb' unless File.exist?(expanded_path)
      source = File.read(expanded_path)

      with_indent do |i|
        puts "Include template from #{expanded_path}".indent(i)
        instance_eval(source, expanded_path, 1)
      end
    end

    def with_indent(&block)
      @indent += INDENT
      block.call(@indent)
    ensure
      @indent -= INDENT
    end
  end
end
