# frozen_string_literal: true

# encoding: UTF-8

require "spec_helper"

describe Aba::Transaction do
  subject(:transaction) { Aba::Transaction.new(transaction_params) }

  let(:transaction_attributes) { {amount: 50050, transaction_code: 53} }

  let(:transaction_params) do
    {
      :account_number => 23432342,
      :transaction_code => transaction_attributes[:transaction_code],
      :amount => transaction_attributes[:amount],
      :account_name => "John Doe",
      :bsb => "345-453",
      :witholding_amount => 87,
      :indicator => "W",
      :lodgement_reference => "R45343",
      :trace_bsb => "123-234",
      :trace_account_number => "4647642",
      :name_of_remitter => "Remitter",
    }
  end

  describe "#to_s" do
    it "should create a transaction row" do
      expect(subject.to_s).to include("1345-453 23432342W530000050050John Doe                        R45343            123-234  4647642Remitter        00000087")
    end

    context 'when supplied amount is negative' do
      let(:transaction_attributes) { {amount: -50050, transaction_code: 53} }

      it "should create a transaction row where the amount does not have a sign" do
        expect(subject.to_s).to include("1345-453 23432342W530000050050John Doe                        R45343            123-234  4647642Remitter        00000087")
      end
    end
  end

  describe "#valid?" do
    it "should be valid" do
      expect(subject.valid?).to eq true
    end

    context "without bsb param" do
      before do
        transaction_params.delete(:bsb)
      end

      it "is invalid" do
        expect(subject.valid?).to eq false
        expect(subject.errors).to eq ["bsb format is incorrect"]
      end
    end

    describe ":amount" do
      subject(:transaction) { Aba::Transaction.new(transaction_params.merge(amount: amount)) }

      context "with 10 digits" do
        let(:amount) { "1234567890" }

        it { is_expected.to be_valid }
      end

      context "with 11 digits" do
        let(:amount) { "12345678901" }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
