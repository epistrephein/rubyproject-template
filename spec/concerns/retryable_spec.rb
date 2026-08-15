# frozen_string_literal: true

RSpec.describe Retryable do
  subject(:worker) { worker_class.new }

  let(:worker_class) do
    Class.new do
      include Retryable
    end
  end

  describe "#with_retries" do
    it "returns the block value when it succeeds immediately" do
      result = worker.with_retries { "ok" }

      expect(result).to eq("ok")
    end

    it "retries the configured number of times and then raises" do
      attempts = 0

      expect do
        worker.with_retries(retries: 2, backoff: 0, jitter: 0) do
          attempts += 1
          raise "boom"
        end
      end.to raise_error(RuntimeError, "boom")

      expect(attempts).to eq(3)
    end

    it "uses a exponential backoff and jitter for each retry attempt" do
      allow(worker).to receive(:sleep)

      expect do
        worker.with_retries(retries: 2, backoff: 2, jitter: 0) { raise "boom" }
      end.to raise_error(RuntimeError, "boom")

      expect(worker).to have_received(:sleep).with(2).ordered
      expect(worker).to have_received(:sleep).with(4).ordered
    end

    it "swallows the exception when swallow_ex is true" do
      result = worker.with_retries(retries: 1, swallow_ex: true, backoff: 0) { raise "boom" }

      expect(result).to be_nil
    end

    it "rescues only configured exception classes" do
      expect(worker).not_to receive(:sleep)

      expect do
        worker.with_retries(retries: 3, rescue_ex: [ArgumentError]) { raise "boom" }
      end.to raise_error(RuntimeError, "boom")
    end
  end
end
