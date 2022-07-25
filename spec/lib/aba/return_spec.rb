# frozen_string_literal: true

# encoding: UTF-8

require "spec_helper"

describe Aba::Return do
  subject(:transaction) { Aba::Return.new(transaction_params) }

  let(:transaction_attributes) { {amount: 50050, transaction_code: 53} }
  let(:transaction_params) do
    {
      :trace_account_number => 23432342,
      :transaction_code => transaction_attributes[:transaction_code],
      :amount => transaction_attributes[:amount],
      :account_name => "John Doe",
      :trace_bsb => "345-453",
      :return_code => 8,
      :lodgement_reference => "R45343",
      :bsb => "123-234",
      :account_number => "4647642",
      :name_of_remitter => "Remitter",
      :original_processing_day => "07",
      :original_user_id => "054321",
    }
  end

  describe "#to_s" do
    it "should create a transaction row" do
      expect(subject.to_s).to include(
        "2123-234  46476428530000050050John Doe                        R45343            345-453 23432342Remitter        07054321")
        # |      |        || |         |                               |                 |      |        |               | |
        # +-bsb  |        || +-amount  +-account_name                  |                 |      |        |               | +-original_user_id
        #        |        |+-transaction_code                          |                 |      |        |               +-original_processing_day
        #        |        +-return_code                                |                 |      |        +-name_of_remitter
        #        +-account_number                                      |                 |      +-trace_account_number
        #                                                              |                 +-trace_bsb
        #                                                              +-lodgement_reference
    end

    context 'when supplied amount is negative' do
      let(:transaction_attributes) { {amount: -50050, transaction_code: 53} }

      it "should create a transaction row where the amount does not have a sign" do
        expect(subject.to_s).to include(
          "2123-234  46476428530000050050John Doe                        R45343            345-453 23432342Remitter        07054321")
          # |      |        || |         |                               |                 |      |        |               | |
          # +-bsb  |        || +-amount  +-account_name                  |                 |      |        |               | +-original_user_id
          #        |        |+-transaction_code                          |                 |      |        |               +-original_processing_day
          #        |        +-return_code                                |                 |      |        +-name_of_remitter
          #        +-account_number                                      |                 |      +-trace_account_number
          #                                                              |                 +-trace_bsb
          #                                                              +-lodgement_reference
      end
    end
  end

  describe "#valid?" do
    it "should be valid" do
      expect(subject.valid?).to eq true
    end

    it "should not be valid" do
      transaction_params.delete(:bsb)
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["bsb format is incorrect"]
    end
  end
end
