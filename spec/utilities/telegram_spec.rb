# frozen_string_literal: true

RSpec.describe Telegram do
  describe ".header" do
    before do
      stub_const("Telegram::APP_NAME", "MyApp")
    end

    it "uses info emoji by default" do
      result = described_class.send(:header, "status")

      expect(result).to eq("💬 *MyApp*: status 💬")
    end

    it "uses urgent emoji for urgent type" do
      result = described_class.send(:header, "status", type: :urgent)

      expect(result).to eq("📣 *MyApp*: status 📣")
    end

    it "uses error emoji for error type" do
      result = described_class.send(:header, "status", type: :error)

      expect(result).to eq("💥 *MyApp*: status 💥")
    end

    it "uses success emoji for success type" do
      result = described_class.send(:header, "status", type: :success)

      expect(result).to eq("🎉 *MyApp*: status 🎉")
    end

    it "falls back to info emoji for unknown type" do
      result = described_class.send(:header, "status", type: :unknown)

      expect(result).to eq("💬 *MyApp*: status 💬")
    end

    it "uses custom emoji when provided" do
      result = described_class.send(:header, "status", type: :unknown, emoji: "!")

      expect(result).to eq("! *MyApp*: status !")
    end
  end

  describe ".message" do
    it "formats and forwards a message body" do
      allow(described_class).to receive(:header).and_return("HEADER")
      allow(described_class).to receive(:call)

      described_class.message("title", "content", type: :success)

      expect(described_class).to have_received(:header).with("title", type: :success)
      expect(described_class).to have_received(:call).with("HEADER\ncontent\n")
    end
  end

  describe ".exception" do
    it "formats exception details and swallows delivery errors" do
      now = Time.parse("2026-03-06T12:34:56Z")
      error = RuntimeError.new("boom")

      allow(Time).to receive(:now).and_return(now)
      allow(described_class).to receive(:header).and_return("ERROR HEADER")
      allow(described_class).to receive(:call)

      described_class.exception(error)

      expect(described_class).to have_received(:header).with("exception", type: :error)
      expect(described_class).to have_received(:call).with(
        "ERROR HEADER\n\n`2026-03-06T12:34:56Z`\n`RuntimeError`\n`boom`\n",
        swallow_ex: true
      )
    end
  end

  describe ".call" do
    it "returns false when telegram is disabled" do
      stub_const("Telegram::ENABLED", false)
      allow(described_class).to receive(:with_retries)

      result = described_class.send(:call, "hello")

      expect(result).to eq(false)
      expect(described_class).not_to have_received(:with_retries)
    end

    it "sends a markdown message through Telegram bot client" do
      stub_const("Telegram::ENABLED", true)
      stub_const("Telegram::TOKEN", "token")
      stub_const("Telegram::USER", 123)

      api = double("telegram_api")
      bot = double("telegram_bot", api: api)

      allow(described_class).to receive(:with_retries).and_yield
      allow(Telegram::Bot::Client).to receive(:new).with("token").and_return(bot)
      allow(api).to receive(:send_message).and_return(:ok)

      result = described_class.send(:call, "hello")

      expect(described_class).to have_received(:with_retries).with(
        rescue_ex:  Telegram::EXCEPTIONS,
        swallow_ex: false,
        backoff:    2
      )
      expect(api).to have_received(:send_message).with(
        chat_id:    123,
        parse_mode: :markdown,
        text:       "hello"
      )
      expect(result).to eq(:ok)
    end

    it "forwards swallow_ex option to retry wrapper" do
      stub_const("Telegram::ENABLED", true)
      stub_const("Telegram::TOKEN", "token")
      stub_const("Telegram::USER", 123)

      api = double("telegram_api")
      bot = double("telegram_bot", api: api)

      allow(described_class).to receive(:with_retries).and_yield
      allow(Telegram::Bot::Client).to receive(:new).and_return(bot)
      allow(api).to receive(:send_message)

      described_class.send(:call, "hello", swallow_ex: true)

      expect(described_class).to have_received(:with_retries).with(
        rescue_ex:  Telegram::EXCEPTIONS,
        swallow_ex: true,
        backoff:    2
      )
    end
  end
end
