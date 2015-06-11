require "aba/version"
require "aba/validations"
require "aba/transaction"

class Aba
  include Aba::Validations

  attr_accessor :bsb, :financial_institution, :user_name, :user_id, :description, :process_at

  validates_bsb :bsb, allow_blank: true

  validates_max_length :user_name,              26
  validates_max_length :user_id,                6
  validates_max_length :description,            12

  validates_length     :financial_institution,  3
  validates_length     :process_at,             6

  def initialize(attrs = {})
    attrs.each do |key, value|
      send("#{key}=", value)
    end

    @transactions = []

    yield self if block_given?
  end

  def to_s
    # Descriptive record
    output = "#{descriptive_record}\r\n"
    
    # Transactions records
    output += @transactions.map{ |t| t.to_s }.join("\r\n")

    # Batch control record
    output += "\r\n#{batch_control_record}"
  end

  def add_transaction(transaction)
    @transactions << transaction
  end

  private

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
    # Blank filled
    output += self.description.to_s.ljust(12)

    # Date on which the payment is to be processed
    # Char position: 75-80
    # Max: 6
    output += self.process_at.rjust(6, "0")

    # Reserved
    # Max: 40
    # Char position: 81-120
    output += " " * 40
  end

  def batch_control_record
    net_total_amount    = 0
    credit_total_amount = 0
    debit_total_amount  = 0

    @transactions.each do |t|
      net_total_amount += t.amount
      credit_total_amount += t.amount if t.amount > 0
      debit_total_amount += t.amount if t.amount < 0
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
    output += net_total_amount.abs.to_s.rjust(10, "0")

    # Credit Total Amount 
    # Max: 10
    # Char position: 31-40
    output += credit_total_amount.abs.to_s.rjust(10, "0")

    # Debit Total Amount 
    # Max: 10
    # Char position: 41-50
    output += debit_total_amount.abs.to_s.rjust(10, "0")

    # Reserved
    # Max: 24
    # Char position: 51-74
    output += " " * 24

    # Total Item Count 
    # Max: 6
    # Char position: 75-80
    output += @transactions.size.to_s.rjust(6, "0")

    # Reserved
    # Max: 40
    # Char position: 81-120
    output += " " * 40
  end
end
