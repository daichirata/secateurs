require "spec_helper"

RSpec.describe Secateurs::Runner do
  describe "#run" do
    subject { runner.run(template_file) }

    before do
      allow_any_instance_of(Secateurs::Test::FakeClient).to receive(:perform_request) do
        response
      end
      allow(STDOUT).to receive(:write)
    end

    let(:runner) do
      Secateurs::Runner.new(options)
    end

    let(:options) do
      { format: "ruby" }
    end

    let(:template_file) do
      support_path("templates/runner")
    end

    let(:template) do
      Secateurs::DSL.parse(template_file)
    end

    describe "not modified" do
      let(:response) do
        Secateurs::Test::FakeResponse.new(200, template.keys[0] => template.values[0])
      end

      it do
        expect_any_instance_of(Secateurs::Client).to_not receive(:put_template)

        subject
      end
    end

    describe "create" do
      let(:response) do
        Secateurs::Test::FakeResponse.new(404)
      end

      it do
        expect_any_instance_of(Secateurs::Client).to \
          receive(:put_template).with(template.keys[0], template.values[0])

        subject
      end
    end

    describe "update" do
      let(:response) do
        Secateurs::Test::FakeResponse.new(200, { template.keys[0] => { "template" => "test-template-*" } })
      end

      it do
        expect_any_instance_of(Secateurs::Client).to \
          receive(:put_template).with(template.keys[0], template.values[0])

        subject
      end
    end

    describe "delete" do
      let(:response) do
        Secateurs::Test::FakeResponse.new(200, { "dummy_template" => { "template" => "test-template-*" } })
      end

      it do
        expect_any_instance_of(Secateurs::Client).to \
          receive(:put_template).with(template.keys[0], template.values[0])

        expect_any_instance_of(Secateurs::Client).to \
          receive(:delete_template).with("dummy_template")

        subject
      end
    end

    describe "dry-run" do
      let(:response) do
        Secateurs::Test::FakeResponse.new(200, { "dummy_template" => { "template" => "test-template-*" } })
      end

      let(:options) do
        { format: "ruby", dry_run: true }
      end

      it do
        expect_any_instance_of(Secateurs::Client).to_not receive(:put_template)
        expect_any_instance_of(Secateurs::Client).to_not receive(:delete_template)

        subject
      end
    end
  end
end
