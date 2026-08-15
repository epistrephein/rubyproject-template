# frozen_string_literal: true

RSpec.describe Loader do
  let(:zeitwerk_loader) { instance_double(Zeitwerk::Loader) }
  let(:lib_dir) { File.expand_path("../lib", __dir__) }

  before do
    described_class.instance_variable_set(:@opts, {})
    described_class.instance_variable_set(:@loader, nil)
  end

  describe ".load!" do
    before do
      allow(Zeitwerk::Loader).to receive(:new).and_return(zeitwerk_loader)
      allow(zeitwerk_loader).to receive(:push_dir)
      allow(zeitwerk_loader).to receive(:collapse)
      allow(zeitwerk_loader).to receive(:setup)
      allow(zeitwerk_loader).to receive(:do_not_eager_load)
      allow(zeitwerk_loader).to receive(:eager_load)
      allow(described_class).to receive(:require).and_return(true)
    end

    it "configures and eager-loads with default options" do
      described_class.load!

      expect(Zeitwerk::Loader).to have_received(:new)
      expect(zeitwerk_loader).to have_received(:push_dir).with(lib_dir)
      expect(zeitwerk_loader).to have_received(:collapse).with("#{lib_dir}/concerns")
      expect(zeitwerk_loader).to have_received(:collapse).with("#{lib_dir}/models")
      expect(zeitwerk_loader).to have_received(:collapse).with("#{lib_dir}/utilities")
      expect(zeitwerk_loader).to have_received(:setup)
      expect(zeitwerk_loader).to have_received(:do_not_eager_load).with("#{lib_dir}/models")
      expect(zeitwerk_loader).to have_received(:eager_load)
    end

    it "supports custom options and can skip eager loading" do
      described_class.load!(
        push:               ["/tmp/project/lib"],
        collapse:           ["custom/collapse"],
        exclude_eager_load: ["custom/excluded"],
        try_require:        ["custom/gem"],
        eager_load:         false
      )

      expect(zeitwerk_loader).to have_received(:push_dir).with("/tmp/project/lib")
      expect(zeitwerk_loader).to have_received(:collapse).with("#{lib_dir}/custom/collapse")
      expect(zeitwerk_loader).to have_received(:do_not_eager_load).with("#{lib_dir}/custom/excluded")
      expect(described_class).to have_received(:require).with("custom/gem")
      expect(zeitwerk_loader).not_to have_received(:eager_load)
    end
  end

  describe ".try_require!" do
    it "ignores LoadError from optional requires" do
      described_class.instance_variable_set(:@opts, { try_require: ["missing/gem"] })

      allow(described_class).to receive(:require).with("missing/gem").and_raise(LoadError)

      expect { described_class.send(:try_require!) }.not_to raise_error
    end

    it "requires all gems when available" do
      described_class.instance_variable_set(:@opts, { try_require: ["first/gem", "second/gem"] })

      allow(described_class).to receive(:require).with("first/gem").and_return(true)
      allow(described_class).to receive(:require).with("second/gem").and_return(true)

      described_class.send(:try_require!)

      expect(described_class).to have_received(:require).with("first/gem")
      expect(described_class).to have_received(:require).with("second/gem")
    end
  end
end
