# frozen_string_literal: true

RSpec.describe Config do
  around do |example|
    original_env = ENV.to_h
    described_class.instance_variable_set(:@configuration, nil)

    example.run
  ensure
    ENV.replace(original_env)
    described_class.instance_variable_set(:@configuration, nil)
  end

  describe ".[]" do
    it "returns env var override when present" do
      ENV["POSTGRES_HOST"] = "env-host"

      expect(described_class[:postgres, :host]).to eq("env-host")
    end

    it "falls back to configuration lookup when env var is absent" do
      described_class.instance_variable_set(
        :@configuration,
        { "postgres" => { "host" => "config-host" } }
      )

      expect(described_class[:postgres, :host]).to eq("config-host")
    end

    it "stringifies args for env key and dig lookup" do
      described_class.instance_variable_set(
        :@configuration,
        { "aws" => { "ses" => { "region" => "us-east-1" } } }
      )

      expect(described_class["aws", :ses, "region"]).to eq("us-east-1")
    end
  end

  describe ".configuration" do
    it "memoizes loaded configuration" do
      config = {
        "postgres" => true,
        "telegram" => true,
        "aws"      => { "s3" => true, "ses" => true }
      }

      allow(YAML).to receive(:load_file).with(Config::CONFIG_FILE).and_return(config)

      first = described_class.send(:configuration)
      second = described_class.send(:configuration)

      expect(first).to eq(config)
      expect(second).to eq(config)
      expect(YAML).to have_received(:load_file).once
    end
  end

  describe ".load_and_validate!" do
    it "loads and returns config when all required keys are present" do
      config = {
        "postgres" => { "host" => "localhost" },
        "telegram" => { "enabled" => true },
        "aws"      => {
          "s3"  => { "bucket" => "bucket" },
          "ses" => { "region" => "us-east-1" }
        }
      }

      allow(YAML).to receive(:load_file).with(Config::CONFIG_FILE).and_return(config)

      expect(described_class.send(:load_and_validate!)).to eq(config)
    end

    it "raises when required keys are missing" do
      config = {
        "postgres" => true,
        "aws"      => { "s3" => true }
      }

      allow(YAML).to receive(:load_file).with(Config::CONFIG_FILE).and_return(config)

      expect { described_class.send(:load_and_validate!) }
        .to raise_error(RuntimeError, "Invalid config file, missing keys: telegram, aws:ses")
    end
  end
end
