# frozen_string_literal: true

class Aba
  class Return < Entry
    include Aba::Validations

    attr_accessor :account_number, :transaction_code, :amount, :account_name,
                  :bsb, :trace_bsb, :trace_account_number, :name_of_remitter,
                  :return_code, :lodgement_reference,
                  :original_processing_day, :original_user_id

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
    validates_integer           :original_processing_day, :unsigned

    # Original User Id
    validates_max_length        :original_user_id, 6
    validates_integer           :original_user_id, :unsigned

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
      @account_number ? @account_number.to_s.delete('-') : nil
    end

    def to_s
      raise 'Transaction data is invalid - check the contents of `errors`' unless valid?

      format('2%-7s%9s%1d%2d%010d%-32s%-18s%-7s%9s%-16s%02d%6s',
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
             original_processing_day.to_i,
             original_user_id)
    end
  end
end
