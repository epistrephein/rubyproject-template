# frozen_string_literal: true

RSpec.describe S3 do
  let(:client) { instance_double(Aws::S3::Client) }

  before do
    stub_const("S3::CLIENT", client)
    stub_const("S3::PREFIX", "prefix/")
    stub_const("S3::BUCKET", "bucket-name")

    allow(described_class).to receive(:with_retries).and_yield
  end

  describe ".put" do
    it "uploads file contents and returns prefixed destination" do
      file_path = "/tmp/report.txt"
      content = "hello"
      digest = Base64.encode64(Digest::MD5.digest(content))

      allow(File).to receive(:basename).with(file_path).and_return("report.txt")
      allow(File).to receive(:read).with(file_path).and_return(content)
      allow(client).to receive(:put_object)

      result = described_class.put(file_path)

      expect(described_class).to have_received(:with_retries).with(
        rescue_ex:  S3::EXCEPTIONS,
        swallow_ex: false,
        backoff:    3
      )

      expect(client).to have_received(:put_object).with(
        bucket:      "bucket-name",
        key:         "prefix/report.txt",
        body:        content,
        content_md5: digest
      )
      expect(result).to eq("prefix/report.txt")
    end

    it "uses custom destination and forwards swallow_ex" do
      file_path = "/tmp/report.txt"

      allow(File).to receive(:read).with(file_path).and_return("hello")
      allow(client).to receive(:put_object)

      result = described_class.put(file_path, to: "archive/final.txt", swallow_ex: true)

      expect(described_class).to have_received(:with_retries).with(
        rescue_ex:  S3::EXCEPTIONS,
        swallow_ex: true,
        backoff:    3
      )
      expect(result).to eq("prefix/archive/final.txt")
    end
  end

  describe ".get" do
    it "returns raw object when no output path is provided" do
      object = instance_double(Aws::S3::Types::GetObjectOutput)

      allow(client).to receive(:get_object).and_return(object)

      result = described_class.get("archive/final.txt")

      expect(client).to have_received(:get_object).with(
        bucket: "bucket-name",
        key:    "prefix/archive/final.txt"
      )
      expect(result).to eq(object)
    end

    it "writes body to file and returns destination when output path is provided" do
      body = instance_double(StringIO)
      object = instance_double(Aws::S3::Types::GetObjectOutput, body: body)

      allow(body).to receive(:read).and_return("downloaded")
      allow(client).to receive(:get_object).and_return(object)
      allow(File).to receive(:write)

      result = described_class.get("archive/final.txt", to: "/tmp/final.txt")

      expect(File).to have_received(:write).with("/tmp/final.txt", "downloaded")
      expect(result).to eq("/tmp/final.txt")
    end
  end

  describe ".delete" do
    it "deletes remote object and returns prefixed path" do
      allow(client).to receive(:delete_object)

      result = described_class.delete("archive/final.txt")

      expect(client).to have_received(:delete_object).with(
        bucket: "bucket-name",
        key:    "prefix/archive/final.txt"
      )
      expect(result).to eq("prefix/archive/final.txt")
    end
  end
end
