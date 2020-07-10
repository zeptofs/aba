class Aba	
  class Entry	
    def initialize(attrs = {})	
      attrs.each do |key, value|	
        send("#{key}=", value)	
      end	
    end	

    def credit?
      (50..57).include?(Integer(transaction_code))
    end

    def debit?
      Integer(transaction_code) == 13
    end
  end	
end
