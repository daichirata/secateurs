module Secateurs
  module Exporter
    class YAMLExporter < Base
      def generate_body
        YAML.dump(templates)
      end
    end
  end
end
