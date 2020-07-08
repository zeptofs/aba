require "aba/version"
require "aba/validations"
require "aba/entry"
require "aba/batch"
require "aba/return"
require "aba/transaction"

class Aba
  def self.batch(attrs = {}, transactions = [])
    Aba::Batch.new(attrs, transactions)
  end
end
