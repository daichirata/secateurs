require "spec_helper"

RSpec.describe Secateurs::Comparer do
  describe "#compare" do
    subject { Secateurs::Comparer.new(false).compare(old, new) }

    context "when there is no differences" do
      let(:old) do
        {
          "key3" => "value3",
          "key1" => "value1",
          "key2" => "value2",
        }
      end

      let(:new) do
        {
          "key1" => "value1",
          "key2" => "value2",
          "key3" => "value3",
        }
      end

      it { is_expected.to eq "" }
    end

    context "when there is a difference" do
      let(:old) do
        {
          "key3" => "value3",
          "key1" => "value1",
          "key2" => "value2",
        }
      end

      let(:new) do
        {
          "key1" => "value1",
          "key3" => "value3",
        }
      end

      it {
        is_expected.to eq <<EOL
 {
   "key1": "value1",
-  "key2": "value2",
   "key3": "value3"
 }
EOL
      }
    end
  end
end
