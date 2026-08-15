# frozen_string_literal: true

RSpec.describe Log do
  LOG_ENV_KEYS = %w[SUPPRESS_LOG LOG_TO_FILE STDOUT_LOG STDERR_LOG].freeze

  around do |example|
    original_env = ENV.to_h
    described_class.instance_variable_set(:@stdout, nil)
    described_class.instance_variable_set(:@stderr, nil)

    LOG_ENV_KEYS.each { |key| ENV.delete(key) }

    example.run
  ensure
    ENV.replace(original_env)
    described_class.instance_variable_set(:@stdout, nil)
    described_class.instance_variable_set(:@stderr, nil)
  end

  describe "::LOG_DIR" do
    it "points to the project log directory" do
      expected = File.expand_path(File.join(__dir__, "..", "log"))

      expect(File.expand_path(described_class::LOG_DIR)).to eq(expected)
    end
  end

  describe ".loggers" do
    it "returns null devices when logging is suppressed" do
      ENV["SUPPRESS_LOG"] = "true"

      expect(described_class.send(:loggers)).to eq([File::NULL, File::NULL])
    end

    it "returns default log file paths when LOG_TO_FILE is enabled" do
      ENV["LOG_TO_FILE"] = "1"

      expect(described_class.send(:loggers)).to eq(
        [
          File.join(described_class::LOG_DIR, "stdout.log"),
          File.join(described_class::LOG_DIR, "stderr.log")
        ]
      )
    end

    it "returns configured log file paths when provided" do
      ENV["LOG_TO_FILE"] = "true"
      ENV["STDOUT_LOG"] = "/tmp/app-stdout.log"
      ENV["STDERR_LOG"] = "/tmp/app-stderr.log"

      expect(described_class.send(:loggers)).to eq(["/tmp/app-stdout.log", "/tmp/app-stderr.log"])
    end

    it "returns stdout and stderr streams by default" do
      expect(described_class.send(:loggers)).to eq([$stdout, $stderr])
    end
  end

  describe ".stdout" do
    it "builds and memoizes stdout logger" do
      allow(described_class).to receive(:loggers).and_return(["out.log", "err.log"])

      logger = instance_double(Logger)
      allow(Logger).to receive(:new).and_return(logger)

      first = described_class.stdout
      second = described_class.stdout

      expect(Logger).to have_received(:new).with("out.log", 10, 1_024_000).once
      expect(first).to eq(logger)
      expect(second).to eq(logger)
    end
  end

  describe ".stderr" do
    it "builds and memoizes stderr logger" do
      allow(described_class).to receive(:loggers).and_return(["out.log", "err.log"])

      logger = instance_double(Logger)
      allow(Logger).to receive(:new).and_return(logger)

      first = described_class.stderr
      second = described_class.stderr

      expect(Logger).to have_received(:new).with("err.log", 10, 1_024_000).once
      expect(first).to eq(logger)
      expect(second).to eq(logger)
    end
  end
end
