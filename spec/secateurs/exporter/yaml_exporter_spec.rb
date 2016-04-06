require "spec_helper"

RSpec.describe Secateurs::Exporter::YAMLExporter do
  describe "#export" do
    subject { described_class.new(options).export }

    before do
      allow_any_instance_of(Secateurs::Test::FakeClient).to receive(:perform_request) do
        response
      end
    end

    let(:response) do
      Secateurs::Test::FakeResponse.new(200, template)
    end

    let(:options) do
      { output: output_path }
    end

    let(:output_path) do
      Tempfile.open("secatuers").path
    end

    let(:template) do
      Secateurs::DSL.parse(support_path("templates/exporter.rb"))
    end

    it "formated using JSON" do
      expect { subject }.to change { File.read(output_path) }.to(YAML.dump(template))
    end
  end
end
