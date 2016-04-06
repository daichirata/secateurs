module Secateurs
  class DSL
    class Converter
      INDENT = 2

      def self.convert(templates)
        templates.map do |name, template|
          self.new(name, template).convert
        end.join("\n")
      end

      def initialize(name, attributes)
        @name = name
        @attributes = attributes
      end

      def convert
        <<-EOF
define_template "#{@name}" do
#{convert_hash(@attributes)}
end
EOF
      end

      private

      def convert_hash(hash, indent = INDENT)
        return if hash.nil?

        hash.map do |k, v|
          "#{convert_hash_key(k)}#{convert_hash_value(k, v)}".indent(indent)
        end.join("\n")
      end

      def convert_hash_key(key)
        if key =~ /[@{}\-\.]/
          "set! \"#{key}\""
        else
          key
        end
      end

      def convert_hash_value(key, value)
        case value
        when Hash
          return " do\n#{convert_hash(value)}\nend"
        when Array
          return " do\n#{convert_array(value)}\nend"
        end

        result = if key =~ /[@{}\-\.]/
                   ","
                 else
                   ""
                 end

        result += if value.instance_of?(String)
                    " \"#{value}\""
                  else
                    " #{value}"
                  end

        result
      end

      def convert_array(array)
        return if array.empty?

        array.map do |v|
          "child! do\n#{convert_hash(v)}\nend".indent(INDENT)
        end.join("\n")
      end
    end
  end
end
