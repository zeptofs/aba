class Aba
  class Transaction
    include Aba::Validations

    attr_accessor :account_number, :transaction_code, :amount, :account_name, 
                  :bsb, :trace_bsb, :trace_account_number, :name_of_remitter, :witholding_amount, 
                  :indicator, :lodgement_reference

    validates_presence_of :bsb, :account_number, :amount, :account_name, :transaction_code,
                          :lodgement_reference, :trace_bsb, :trace_account_number, :name_of_remitter
    
    validates_bsb :bsb
    validates_bsb :trace_bsb

    validates_max_length :account_number,         9
    validates_max_length :indicator,              1
    validates_max_length :transaction_code,       2
    validates_max_length :account_name,           32
    validates_max_length :lodgement_reference,    18
    validates_max_length :trace_account_number,   9
    validates_max_length :name_of_remitter,       16

    def initialize(attrs = {})
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end
    
    def to_s
      # Record type
      output = "1"

      # BSB of account
      output += bsb

      # Account number
      output += account_number.to_s.rjust(9, " ")

      # Withholding Tax Indicator
      # "N" – for new or varied Bank/State/Branch number or name details, otherwise blank filled.
      # "W" – dividend paid to a resident of a country where a double tax agreement is in force.
      # "X" – dividend paid to a resident of any other country.
      # "Y" – interest paid to all non-residents.
      output += indicator.to_s.ljust(1, " ")

      # Transaction Code
      # 50 General Credit. 
      # 53 Payroll. 
      # 54 Pension. 
      # 56 Dividend. 
      # 57 Debenture Interest. 
      # 13 General Debit.
      output += transaction_code.to_s

      # Amount to be credited or debited
      output += amount.abs.to_s.rjust(10, "0")

      # Title of Account
      output += account_name.ljust(32, " ")

      # Lodgement Reference Produced on the recipient’s Account Statement. 
      output += lodgement_reference.ljust(18, " ")     

      # Trace BSB Number
      output += trace_bsb

      # Trace Account Number 
      output += trace_account_number.to_s.rjust(9, " ")

      # Name of Remitter Produced on the recipient’s Account Statement
      output += name_of_remitter.ljust(16, " ")

      # Withholding amount in cents
      output += (witholding_amount || 0).abs.to_s.rjust(8, "0")
    end
  end
end
