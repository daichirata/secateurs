require "spec_helper"

RSpec.describe Secateurs::Parser do
  describe "#parse" do
    subject { Secateurs::Parser.new(format).parse(path) }

    let(:template) do
      {
        "template" => "te*",
        "order" => 1,
        "settings" => {
          "number_of_shards" => "1"
        },
        "mappings" => {
          "_default_" => {
            "dynamic_templates" => [
              {
                "template1" => {
                  "match" => "*",
                  "mapping" => {
                    "index" => "not_analyzed"
                  }
                }
              }
            ],
            "properties" => {
              "@timestamp" => {
                "type" => "date"
              },
              "host_name" => {
                "type" => "string",
                "index" => "not_analyzed"
              },
              "created_at" => {
                "type" => "date",
                "format" => "EEE MMM dd HH:mm:ss Z YYYY"
              },
              "type1" => {
                "type2" => {
                  "type" => "string"
                }
              },
              "props" => {
                "type" => "prop_test"
              }
            }
          },
          "type1" => {
            "_source" => {
              "enabled" => false
            }
          },
        },
        "aliases" => {
          "alias2" => {
            "filter" => {
              "term" => {
                "user" => "kimchy"
              }
            },
            "index_routing" => "kimchy",
            "search_routing" => "kimchy"
          }
        }
      }
    end

    describe "format ruby" do
      let(:format) do
        "ruby"
      end

      let(:path) do
        support_path("templates/parser.rb")
      end

      it "should parse dsl to hash" do
        is_expected.to eq({ "template-parser-ruby" => template })
      end
    end

    describe "format json" do
      let(:format) do
        "json"
      end

      let(:path) do
        support_path("templates/parser.json")
      end

      it "should parse json to hash" do
        is_expected.to eq({ "template-parser-json" => template })
      end
    end

    describe "format yaml" do
      let(:format) do
        "yaml"
      end

      let(:path) do
        support_path("templates/parser.yml")
      end

      it "should parse json to hash" do
        is_expected.to eq({ "template-parser-yaml" => template })
      end
    end
  end
end
