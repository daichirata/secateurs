require "elasticsearch"

module Secateurs
  class Client
    def self.from_options(options)
      self.new(options[:host], options[:port], options[:verbose])
    end

    def initialize(host, port, verbose = true)
      @client = Elasticsearch::Client.new(host: host, port: port, log: verbose)
    end

    def get_template(name = nil)
      @client.indices.get_template(name: name, ignore: [404]) || {}
    end

    def put_template(name, body)
      @client.indices.put_template(name: name, body: body)
    end

    def delete_template(name)
      @client.indices.delete_template(name: name)
    end
  end
end
