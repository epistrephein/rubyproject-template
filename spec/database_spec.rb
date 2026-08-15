# frozen_string_literal: true

RSpec.describe Database do
  describe "Sequel timezone setup" do
    it "configures database and application timezones" do
      expect(Sequel.database_timezone).to eq(:utc)
      expect(Sequel.application_timezone).to eq(:local)
    end
  end

  describe "class-level delegation" do
    let(:db) do
      Object.new.tap do |obj|
        def obj.with_kwargs(*args, **kwargs)
          [args, kwargs]
        end
      end
    end

    before do
      stub_const("Database::DB", db)
    end

    it "delegates missing class methods to DB with args and kwargs" do
      result = described_class.with_kwargs(1, 2, key: "value")

      expect(result).to eq([[1, 2], { key: "value" }])
    end

    it "reports delegated methods through respond_to?" do
      expect(described_class.respond_to?(:with_kwargs)).to eq(true)
    end

    it "raises NoMethodError for methods DB does not implement" do
      expect { described_class.not_defined_anywhere }.to raise_error(NoMethodError)
    end
  end
end
