# frozen_string_literal: true

class Aba
  class Batch
    include Aba::Validations

    attr_accessor :bsb, :financial_institution, :user_name, :user_id, :description, :process_at, :entries

    # BSB
    validates_bsb         :bsb, allow_blank: true

    # Financial Institution
    validates_length      :financial_institution, 3

    # User Name
    validates_presence_of :user_name
    validates_max_length  :user_name, 26
    validates_becs        :user_name

    # User ID
    validates_presence_of :user_id
    validates_max_length  :user_id, 6
    validates_integer     :user_id, false

    # Description
    validates_max_length  :description, 12
    validates_becs        :description

    # Process at Date
    validates_length      :process_at, 6
    validates_integer     :process_at, false


    def initialize(attrs = {}, transactions = [])
      attrs.each do |key, value|
        send("#{key}=", value)
      end

      @entries = []

      unless transactions.nil? || transactions.empty?
        transactions.to_a.each do |t|
          self.add_transaction(t) unless t.nil? || t.empty?
        end
      end

      yield self if block_given?
    end

    def to_s
      raise RuntimeError, 'No entries present - add one using `add_transaction` or `add_return`' if entries.empty?
      raise RuntimeError, 'ABA data is invalid - check the contents of `errors`' unless valid?

      # Descriptive record
      output = "#{descriptive_record}\r\n"

      # Transactions records
      output += entries.map { |t| t.to_s }.join("\r\n")

      # Batch control record
      output += "\r\n#{batch_control_record}"
    end

    def add_transaction(attrs = {})
      add_entry(Aba::Transaction, attrs)
    end

    def add_return(attrs = {})
      add_entry(Aba::Return, attrs)
    end

    def transactions
      entries.select { |entry| entry.instance_of?(Aba::Transaction) }
    end

    def transactions_valid?
      !transactions.map { |t| t.valid? }.include?(false)
    end

    def valid?
      !has_errors? && !has_entry_errors?
    end

    def errors
      # Run validations
      has_errors?
      has_entry_errors?

      # Build errors
      all_errors = {}
      all_errors[:aba] = self.error_collection unless self.error_collection.empty?
      entry_error_collection = entries.each_with_index.map { |t, i| [i, t.error_collection] }.reject { |e| e[1].nil? || e[1].empty? }.to_h
      all_errors[:entries] = entry_error_collection unless entry_error_collection.empty?

      all_errors unless all_errors.empty?
    end

    private

    def add_entry(type, attrs)
      (attrs.instance_of?(type) ? attrs : type.new(attrs)).tap do |entry|
        entries << entry
      end
    end

    def has_entry_errors?
      entries.map { |t| t.valid? }.include?(false)
    end

    def descriptive_record
      # Record type
      # Max: 1
      # Char position: 1
      output = "0"

      # Optional branch number of the funds account with a hyphen in the 4th character position
      # Char position: 2-18
      # Max: 17
      # Blank filled
      output += self.bsb.nil? ? " " * 17 : self.bsb.to_s.ljust(17)

      # Sequence number
      # Char position: 19-20
      # Max: 2
      # Zero padded
      output += "01"

      # Name of user financial instituion
      # Max: 3
      # Char position: 21-23
      output += self.financial_institution.to_s

      # Reserved
      # Max: 7
      # Char position: 24-30
      output += " " * 7

      # Name of User supplying File
      # Char position: 31-56
      # Max: 26
      # Full BECS character set valid
      # Blank filled
      output += self.user_name.to_s.ljust(26)

      # Direct Entry User ID
      # Char position: 57-62
      # Max: 6
      # Zero padded
      output += self.user_id.to_s.rjust(6, "0")

      # Description of payments in the file (e.g. Payroll, Creditors etc.)
      # Char position: 63-74
      # Max: 12
      # Full BECS character set valid
      # Blank filled
      output += self.description.to_s.ljust(12)

      # Date on which the payment is to be processed
      # Char position: 75-80
      # Max: 6
      output += self.process_at.to_s.rjust(6, "0")

      # Reserved
      # Max: 40
      # Char position: 81-120
      output += " " * 40
    end

    def batch_control_record
      credit_total_amount = 0
      debit_total_amount  = 0

      entries.each do |entry|
        if entry.debit?
          debit_total_amount += Integer(entry.amount).abs
        else
          credit_total_amount += Integer(entry.amount).abs
        end
      end

      # Record type
      # Max: 1
      # Char position: 1
      output = "7"

      # BSB Format Filler
      # Max: 7
      # Char position: 2-8
      output += "999-999"

      # Reserved
      # Max: 12
      # Char position: 9-20
      output += " " * 12

      # Net total
      # Max: 10
      # Char position: 21-30
      output += (credit_total_amount - debit_total_amount).abs.to_s.rjust(10, "0")

      # Credit Total Amount
      # Max: 10
      # Char position: 31-40
      output += credit_total_amount.to_s.rjust(10, "0")

      # Debit Total Amount
      # Max: 10
      # Char position: 41-50
      output += debit_total_amount.to_s.rjust(10, "0")

      # Reserved
      # Max: 24
      # Char position: 51-74
      output += " " * 24

      # Total Item Count
      # Max: 6
      # Char position: 75-80
      output += entries.size.to_s.rjust(6, "0")

      # Reserved
      # Max: 40
      # Char position: 81-120
      output += " " * 40
    end
  end
end
