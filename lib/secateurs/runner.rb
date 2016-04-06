module Secateurs
  class Runner
    def initialize(options)
      @options = options
      @client = Client.from_options(options)
    end

    def run(file)
      es_templates = @client.get_template
      templates = Parser.new(@options[:format]).parse(file)

      changed = {}
      deleted = []

      comparer = Comparer.new(@options[:color])

      (es_templates.keys | templates.keys).each do |name|
        result = comparer.compare(es_templates[name], templates[name])

        unless result.blank?
          puts
          puts "Comparing changes `#{name}`"
          puts result

          if templates[name].nil?
            deleted << name
          else
            changed[name] = templates[name]
          end
        end
      end

      unless @options[:dry_run]
        changed.each do |name, template|
          @client.put_template(name, template)
        end

        deleted.each do |name|
          @client.delete_template(name)
        end
      end
    end
  end
end
