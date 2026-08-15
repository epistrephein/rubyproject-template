# frozen_string_literal: true

RSpec.describe Ses do
  let(:client) { instance_double(Aws::SES::Client) }

  before do
    stub_const("Ses::CLIENT", client)
    stub_const("Ses::FROM_NAME", "Sender")
    stub_const("Ses::FROM_EMAIL", "sender@example.com")
    stub_const("Ses::ENCODING", "UTF-8")
    stub_const("Ses::TO_EMAIL", "default@example.com")

    allow(described_class).to receive(:with_retries).and_yield
  end

  describe ".send" do
    it "sends an email payload with default recipient" do
      response = instance_double(Aws::SES::Types::SendEmailResponse)
      allow(client).to receive(:send_email).and_return(response)

      result = described_class.send(subject: "Subject", html: "<b>Hi</b>", text: "Hi")

      expect(described_class).to have_received(:with_retries).with(
        rescue_ex:  Ses::EXCEPTIONS,
        swallow_ex: false,
        backoff:    3
      )

      expect(client).to have_received(:send_email).with(
        destination: { to_addresses: ["default@example.com"] },
        message:     {
          subject: { charset: "UTF-8", data: "Subject" },
          body:    {
            html: { charset: "UTF-8", data: "<b>Hi</b>" },
            text: { charset: "UTF-8", data: "Hi" }
          }
        },
        source:      "Sender <sender@example.com>"
      )
      expect(result).to eq(response)
    end

    it "supports multiple recipients" do
      allow(client).to receive(:send_email)

      described_class.send(
        subject: "Subject",
        html:    "<b>Hi</b>",
        text:    "Hi",
        to:      ["a@example.com", "b@example.com"]
      )

      expect(client).to have_received(:send_email).with(
        hash_including(destination: { to_addresses: ["a@example.com", "b@example.com"] })
      )
    end

    it "forwards swallow_ex to retry wrapper" do
      allow(client).to receive(:send_email)

      described_class.send(subject: "Subject", html: "<b>Hi</b>", text: "Hi", swallow_ex: true)

      expect(described_class).to have_received(:with_retries).with(
        rescue_ex:  Ses::EXCEPTIONS,
        swallow_ex: true,
        backoff:    3
      )
    end
  end
end
