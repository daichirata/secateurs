module Secateurs
  module Exporter
    class RubyExporter < Base
      MAGIC_COMMENT = <<-EOS.strip_heredoc
        # -*- mode: ruby -*-
        # vi: set ft=ruby :
      EOS

      def generate_body
        with_magic_comment(DSL::Converter.convert(templates))
      end

      def with_magic_comment(body)
        if output_file && File.extname(output_file) == ".rb"
          body
        else
          MAGIC_COMMENT + "\n" + body
        end
      end
    end
  end
end
