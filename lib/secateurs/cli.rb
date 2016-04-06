require "thor"
require "secateurs"

module Secateurs
  class CLI < Thor
    class_option :verbose, type: :boolean

    def self.define_default_options
      option :host,   type: :string,  aliases: ["-h"], default: "localhost"
      option :port,   type: :numeric, aliases: ["-p"], default: 9200
      option :format, type: :string,  aliases: ["-f"], default: "ruby", enum: ["ruby", "json", "yaml"]
    end

    desc "apply FILE", "apply index template file."
    define_default_options
    option :color,   type: :boolean, default: true
    option :dry_run, type: :boolean, default: false
    def apply(file)
      raise "Please specify template file." if file.nil?

      msg = "Apply `#{file}` to index template"
      msg += " (dry-run)" if options[:dry_run]
      puts msg

      Runner.new(options).run(file)
    end

    desc "export", "export index template to local."
    define_default_options
    option :output, type: :string,  aliases: ["-o"]
    option :split,  type: :boolean, default: false
    def export
      Exporter.build(options).export
    end
  end
end
