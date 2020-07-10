class Aba	
  class Entry	
    def initialize(attrs = {})	
      attrs.each do |key, value|	
        send("#{key}=", value)	
      end	
    end	

    def credit?
      (50..57).include?(transaction_code.to_i)
    end

    def debit?
      transaction_code.to_i == 13
    end
  end	
end
