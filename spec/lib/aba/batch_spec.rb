# encoding: UTF-8

require "spec_helper"

describe Aba::Batch do
  subject(:batch) do
    Aba::Batch.new(
      financial_institution: "WPC",
      user_name: "John Doe",
      user_id: "466364",
      description: "Payroll",
      process_at: "190615",
    )
  end

  let(:transactions_attributes) { [{amount: 30, transaction_code: 50}, {amount: 20, transaction_code: 13}] }
  let(:returns_attributes) { [{amount: 3, transaction_code: 50}, {amount: 2, transaction_code: 13}] }

  before do
    transactions_attributes.each do |attr|
      transaction = Aba::Transaction.new(
        bsb: '342-342',
        account_number: '3244654',
        amount: attr[:amount],
        account_name: 'John Doe',
        transaction_code: attr[:transaction_code],
        lodgement_reference: 'R435564',
        trace_bsb: '453-543',
        trace_account_number: '45656733',
        name_of_remitter: 'Remitter',
      )

      batch.add_transaction(transaction)
    end

    returns_attributes.map do |attr|
      ret = Aba::Return.new(
        bsb: '453-543',
        account_number: '45656733',
        amount: attr[:amount],
        account_name: 'John Doe',
        transaction_code: attr[:transaction_code],
        lodgement_reference: 'R435564',
        trace_bsb: '342-342',
        trace_account_number: '3244654',
        name_of_remitter: 'Remitter',
        return_code: 8,
        original_user_id: 654321,
        original_processing_day: 12,
      )

      batch.add_return(ret)
    end
  end

  describe "#to_s" do
    context 'when descriptive record' do
      context 'without bsb' do
        it "should return a string containing the descriptive record without the bsb" do
          expect(batch.to_s).to include("0                 01WPC       John Doe                  466364Payroll     190615                                        \r\n")
        end
      end

      context 'with bsb' do
        before { batch.bsb = "123-345" }

        it "should return a string containing the descriptive record with the bsb" do
          expect(batch.to_s).to include("0123-345          01WPC       John Doe                  466364Payroll     190615                                        \r\n")
        end
      end
    end


    context 'when detail record' do
      it "should contain transaction & return records" do
        expect(batch.to_s).to include("1342-342  3244654 500000000030John Doe                        R435564           453-543 45656733Remitter        00000000\r\n")
        expect(batch.to_s).to include("1342-342  3244654 130000000020John Doe                        R435564           453-543 45656733Remitter        00000000\r\n")
        expect(batch.to_s).to include("2453-543 456567338500000000003John Doe                        R435564           342-342  3244654Remitter        12654321\r\n")
        expect(batch.to_s).to include("2453-543 456567338130000000002John Doe                        R435564           342-342  3244654Remitter        12654321\r\n")
      end
    end

    context 'when file total record' do
      context 'with unbalanced transactions' do
        it "should return a string where the net total is not zero" do
          expect(batch.to_s).to include("7999-999            000000001100000000330000000022                        000004                                        ")
          #                                                  | Total  || Credit || Debit  |
        end
      end

      context 'with balanced transactions' do
        let(:transactions_attributes) do
          [{amount: 30, transaction_code: 50}, {amount: 30, transaction_code: 13}, {amount: 30, transaction_code: 50}]
        end
        let(:returns_attributes) do
          [{amount: 3, transaction_code: 50}, {amount: 3, transaction_code: 13}, {amount: 30, transaction_code: 13}]
        end

        it "should return a string where the net total is zero" do
          expect(batch.to_s).to include("7999-999            000000000000000000630000000063                        000006                                        ")
          #                                                  | Total  || Credit || Debit  |
        end
      end
    end
  end

  describe "#errors" do
    it "is empty" do
      expect(batch.errors).to be_nil
    end

    context "with an invalid amount" do
      let(:transactions_attributes) do
        [{amount: 1, transaction_code: 50}, {amount: 'abc', transaction_code: 13}, {amount: 'def', transaction_code: 50}]
      end

      it "reports the errors" do
        expect(batch.errors).to eq(:entries => { 1 => ["amount must be a number"], 2 => ["amount must be a number"] })
      end
    end
  end
end
