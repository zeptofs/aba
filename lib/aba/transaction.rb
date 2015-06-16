class Aba
  class Transaction
    include Aba::Validations

    attr_accessor :account_number, :transaction_code, :amount, :account_name,
                  :bsb, :trace_bsb, :trace_account_number, :name_of_remitter,
                  :witholding_amount, :indicator, :lodgement_reference

    # BSB
    validates_bsb               :bsb

    # Account Number
    validates_account_number    :account_number

    # Indicator
    validates_indicator         :indicator

    # Transaction Code
    validates_transaction_code  :transaction_code

    # Amount
    validates_integer           :amount

    # Account Name
    validates_max_length        :account_name, 32
    validates_becs              :account_name

    # Lodgement Reference
    validates_max_length        :lodgement_reference, 18
    validates_becs              :lodgement_reference

    # Trace Record
    validates_bsb               :trace_bsb
    validates_account_number    :trace_account_number

    # Name of Remitter
    validates_max_length        :name_of_remitter, 16
    validates_becs              :name_of_remitter


    def initialize(attrs = {})
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end

    # Fall back to blank string
    def indicator
      @indicator || ' '
    end

    # Fall back to 53
    def transaction_code
      @transaction_code || 53
    end

    # Fall back to 0
    def amount
      @amount || 0
    end

    # Fall back to BSB
    def trace_bsb
      @trace_bsb || bsb
    end

    # Fall back to Account Number
    def trace_account_number
      @trace_account_number || account_number
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
      # "T" - for a drawing under a Transaction Negotiation Authority.
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
      # Full BECS character set valid
      output += account_name.ljust(32, " ")

      # Lodgement Reference Produced on the recipient’s Account Statement.
      # Full BECS character set valid
      output += lodgement_reference.ljust(18, " ")

      # Trace BSB Number
      output += trace_bsb

      # Trace Account Number
      output += trace_account_number.to_s.rjust(9, " ")

      # Name of Remitter Produced on the recipient’s Account Statement
      # Full BECS character set valid
      output += name_of_remitter.ljust(16, " ")

      # Withholding amount in cents
      output += (witholding_amount || 0).abs.to_s.rjust(8, "0")
    end
  end
end
