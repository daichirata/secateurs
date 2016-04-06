require "spec_helper"

RSpec.describe Secateurs::DSL::Converter do
  describe "#convert" do
    subject { Secateurs::DSL::Converter.new(name, attributes).convert }

    let(:name) do
      "test-template"
    end

    let(:attributes) do
      {
        "template" => "te*",
        "settings" => {
          "number_of_shards" => 1
        },
        "mappings" => {
          "_default_" => {
            "dynamic_templates" => [
              "template1" => {
                "match" => "*",
                "mapping" => {
                  "ignore_above" => 1024,
                  "index" => "not_analyzed",
                  "type" => "{dynamic_type}",
                  "doc_values" => true,
                }
              }
            ],
            "_all" => {
              "norms" => {
                "enabled" => false
              },
              "enabled" => true
            }
          },
          "type1" => {
            "_source" => {
              "enabled" => false
            }
          },
          "properties" => {
            "@timestamp" => {
              "type" => "date"
            }
          }
        }
      }
    end

    it "should convert to dsl in ruby" do
      is_expected.to eq <<EOF
define_template "test-template" do
  template "te*"
  settings do
    number_of_shards 1
  end
  mappings do
    _default_ do
      dynamic_templates do
        child! do
          template1 do
            match "*"
            mapping do
              ignore_above 1024
              index "not_analyzed"
              type "{dynamic_type}"
              doc_values true
            end
          end
        end
      end
      _all do
        norms do
          enabled false
        end
        enabled true
      end
    end
    type1 do
      _source do
        enabled false
      end
    end
    properties do
      set! "@timestamp" do
        type "date"
      end
    end
  end
end
EOF
    end
  end
end
