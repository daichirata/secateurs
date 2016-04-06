module Secateurs
  module Test
    class FakeClient
      include Elasticsearch::API

      def initialize(*)
      end

      def perform_request(*)
      end
    end

    FakeResponse = Struct.new(:status, :body, :headers) do
      def status
        values[0] || 200
      end

      def body
        values[1] || {}
      end

      def headers
        values[2] || {}
      end
    end

    class NotFound < StandardError; end
  end
end
