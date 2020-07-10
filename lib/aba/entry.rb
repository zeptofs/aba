class Aba	
  class Entry	
    def initialize(attrs = {})	
      attrs.each do |key, value|	
        send("#{key}=", value)	
      end	
    end	

    def credit?
      Validations::CREDIT_TRANSACTION_CODES.include?(transaction_code.to_i)
    end

    def debit?
      Validations::DEBIT_TRANSACTION_CODES.include?(transaction_code.to_i)
    end
  end	
end
