class Aba
  class Return
    include Aba::Validations

    attr_accessor :account_number, :transaction_code, :amount, :account_name,
                  :bsb, :trace_bsb, :trace_account_number, :name_of_remitter,
                  :return_code, :lodgement_reference,
                  :original_day_of_processing, :original_user_id

    # BSB
    validates_bsb               :bsb

    # Account Number
    validates_account_number    :account_number

    # Indicator
    validates_return_code       :return_code

    # Transaction Code
    validates_transaction_code  :transaction_code

    # Amount
    validates_integer           :amount

    # Original Day of Processing
    validates_integer           :original_day_of_processing

    # Original User Id
    validates_max_length        :original_user_id, 6

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

    # Allow dashes to be input, but remove them from output
    def account_number
      @account_number ? @account_number.to_s.delete('-') : nil
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
      @trace_account_number ? @trace_account_number.to_s.delete('-') : account_number
    end

    def name_of_remitter
      @name_of_remitter || ''
    end

    def to_s
      raise 'Transaction data is invalid - check the contents of `errors`' unless valid?

      format('2%-7s%9s%1d%2d%010d%-32s%-18s%-7s%9s%-16s%2d%6d',
             bsb,
             account_number,
             return_code,
             transaction_code,
             amount.to_i.abs,
             account_name,
             lodgement_reference,
             trace_bsb,
             trace_account_number,
             name_of_remitter,
             original_day_of_processing,
             original_user_id)
    end
  end
end
