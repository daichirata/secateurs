require "fileutils"

module Secateurs
  module Exporter
    class SplitExporter < RubyExporter
      def export
        export_splitting_templates
        super
      end

      def generate_body
        body = templates.keys.map do |n|
          "include_template \"#{n}\"\n"
        end.join

        with_magic_comment(body)
      end

      def output_file
        super || "Templatefile"
      end

      def output_dir
        File.dirname(output_file)
      end

      def export_splitting_templates
        FileUtils.mkdir_p(output_dir)

        templates.each do |name, template|
          body = DSL::Converter.convert({ name => template })
          output_file = File.join(output_dir, name + ".rb")

          write(output_file, body)
        end
      end
    end
  end
end
