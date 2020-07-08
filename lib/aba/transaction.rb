class Aba
  class Transaction < Entry
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
    validates_amount            :amount

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


    # Allow dashes to be input, but remove them from output
    def account_number
      @account_number ? @account_number.to_s.gsub('-', '') : nil
    end

    # Fall back to blank string
    def indicator
      @indicator || Aba::Validations::INDICATORS.first
    end

    # Fall back to 50
    def transaction_code
      @transaction_code || 50
    end

    # Fall back to 0
    def amount
      @amount || 0
    end

    # Fall back to empty string
    def account_name
      @account_name || ''
    end

    # Fall back to empty string
    def lodgement_reference
      @lodgement_reference || ''
    end

    # Fall back to BSB
    def trace_bsb
      @trace_bsb || bsb
    end

    # Fall back to Account Number
    def trace_account_number
      @trace_account_number ? @trace_account_number.to_s.gsub('-', '') : account_number
    end

    def name_of_remitter
      @name_of_remitter || ''
    end

    def to_s
      raise RuntimeError, 'Transaction data is invalid - check the contents of `errors`' unless valid?

      # Record type
      output = "1"

      # BSB of account
      output += bsb

      # Account number
      #raise RuntimeError, 'Transaction is missing account_number' unless account_number
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
      output += amount.to_i.abs.to_s.rjust(10, "0")

      # Title of Account
      # Full BECS character set valid
      output += account_name.to_s.ljust(32, " ")

      # Lodgement Reference Produced on the recipient’s Account Statement.
      # Full BECS character set valid
      output += lodgement_reference.to_s.ljust(18, " ")

      # Trace BSB Number
      output += trace_bsb

      # Trace Account Number
      output += trace_account_number.to_s.rjust(9, " ")

      # Name of Remitter Produced on the recipient’s Account Statement
      # Full BECS character set valid
      output += name_of_remitter.to_s.ljust(16, " ")

      # Withholding amount in cents
      output += (witholding_amount || 0).abs.to_s.rjust(8, "0")
    end
  end
end
