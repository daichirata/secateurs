require "spec_helper"

RSpec.describe Secateurs::Exporter do
  describe ".build" do
    subject { Secateurs::Exporter.build(options) }

    describe "json" do
      let(:options) do
        { format: "json" }
      end

      it { is_expected.to be_instance_of(Secateurs::Exporter::JSONExporter) }
    end

    describe "ruby" do
      let(:options) do
        { format: "ruby" }
      end

      it { is_expected.to be_instance_of(Secateurs::Exporter::RubyExporter) }
    end

    describe "yaml" do
      let(:options) do
        { format: "yaml" }
      end

      it { is_expected.to be_instance_of(Secateurs::Exporter::YAMLExporter) }
    end

    describe "split" do
      let(:options) do
        { split: true, format: "json" }
      end

      it { is_expected.to be_instance_of(Secateurs::Exporter::SplitExporter) }
    end
  end
end
