require "spec_helper"

describe Aba do
  subject(:aba) { Aba.new }

  describe "#transaction" do
    it "should create a transaction" do
      subject.transaction do |t|
        # Do stuff
      end

      expect(subject.instance_variable_get(:@transactions).size).to eq 1
    end

    it "should assign default values to created transaction" do
      subject.transaction do |t|
        # Do stuff
      end

      created_transaction = subject.instance_variable_get(:@transactions).first

      expect(created_transaction.trace_bsb).to eq aba.bsb
      expect(created_transaction.trace_account_number).to eq aba.account_number
      expect(created_transaction.name_of_remitter).to eq aba.name_of_remitter
    end
  end
end