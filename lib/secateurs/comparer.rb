require "diffy"

module Secateurs
  class Comparer
    def initialize(colorize = true)
      @output_format = colorize ? :color : :text
    end

    def compare(old, new)
      Diffy::Diff.new(
        convert_json(old),
        convert_json(new),
        diff: "-u"
      ).to_s(@output_format)
    end

    private

    def convert_json(hash)
      (hash ? JSON.pretty_generate(sort_by_key(hash)) : "") + "\n"
    end

    def sort_by_key(hash)
      hash.keys.sort.reduce({}) do |seed, key|
        seed[key] = case (value = hash[key])
                    when Hash
                      sort_by_key(value)
                    else
                      value
                    end
        seed
      end
    end
  end
end
