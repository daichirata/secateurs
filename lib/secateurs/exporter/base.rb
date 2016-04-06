module Secateurs
  module Exporter
    class Base
      def initialize(options)
        @options = options
        @client = Client.from_options(options)
      end

      def export
        body = generate_body

        if output_file
          write(output_file, body)

          puts "Export index template to #{File.expand_path(output_file)}"
        else
          puts body
        end
      end

      private

      def generate_body
        raise NotImplementedError
      end

      def output_file
        @options[:output]
      end

      def templates
        @templates ||= @client.get_template
      end

      def write(output_file, body)
        File.open(output_file, "wb") do |file|
          file << body
        end
      end
    end
  end
end
