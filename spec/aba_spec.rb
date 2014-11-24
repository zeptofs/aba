require "spec_helper"

describe Aba do
  subject(:aba) do
    aba = Aba.new(bsb: "123-345", financial_institution: "WPC", user_name: "John Doe", 
      user_id: "466364", description: "Payroll", process_at: Time.new(2014, 12, 01, 10, 22, 0)) 

    [30, -20].each do |amount|
      aba.transactions << Aba::Transaction.new(
        :bsb => "342-342", 
        :account_number => "3244654", 
        :amount => amount, 
        :account_name => "John Doe", 
        :payment_id => "P2345543", 
        :transaction_code => 53,
        :lodgement_reference => "R435564", 
        :trace_bsb => "453-543", 
        :trace_account_number => "45656733", 
        :name_of_remitter => "Remitter"
      )
    end

    aba
  end

  describe "#to_s" do
    it "should contain a descriptive record" do
      expect(subject.to_s).to include("0123-345          01WPC       John Doe                  466364Payroll     0112141022                                    \r\n")
    end

    it "should contain transactions records" do
      expect(subject.to_s).to include("1342-342  3244654 530000000030John Doe                        R435564           453-543 45656733Remitter        00000000\r\n")
      expect(subject.to_s).to include("1342-342  3244654 530000000020John Doe                        R435564           453-543 45656733Remitter        00000000\r\n")
    end

    it "should contain a batch control record" do
      expect(subject.to_s).to include("7999-999            000000001000000000300000000020                        000002                                        ")
    end
  end
end