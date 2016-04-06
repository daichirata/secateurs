module Secateurs
  module Exporter
    class JSONExporter < Base
      def generate_body
        JSON.pretty_generate(templates)
      end
    end
  end
end
