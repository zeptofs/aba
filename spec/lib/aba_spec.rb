# frozen_string_literal: true

# encoding: UTF-8

require "spec_helper"

describe Aba do
  describe ".batch" do
    it "initialize instance of Aba::Batch with passed arguments" do
      attributes = double.as_null_object
      transactions = double.as_null_object

      expect(Aba::Batch).to receive(:new).with(attributes, transactions)
      described_class.batch(attributes, transactions)
    end

    it "returns instance of Aba::Batch" do
      obj = described_class.batch(double.as_null_object, double.as_null_object)

      expect(obj).to be_a(Aba::Batch)
    end
  end
end
