require "aba/version"
require "aba/validations"
require "aba/batch"
require "aba/transaction"

class Aba
  def self.batch(attrs = {}, transactions = [])
    Aba::Batch.new(attrs, transactions)
  end
end
