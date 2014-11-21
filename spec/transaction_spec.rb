require "spec_helper"

describe Aba::Transaction do
  let(:transaction_params) { {trace_bsb: "123-234", trace_account_number: "4647642", name_of_remitter: "REMITTER"} }
  subject(:transaction) { Aba::Transaction.new(transaction_params) }

  describe "#to_s" do
    it "should create a 120 caracter line" do
      subject.bsb = "999-999"
      expect(subject.to_s.length).to eq 120
    end
  end
end