# Aba

The purpose of this gem is to generate an ABA (Australian Banking Association) file. It is a format used by banks to allow for batch transaction.

## Usage

```ruby
require 'aba'

aba = Aba.new(
  bsb: "123-345", 
  financial_institution: "WPC", 
  user_name: "John Doe", 
  user_id: "466364", 
  description: "Payroll", 
  process_at: Time.now
)

# Add transactions
10.times do
  aba.add_transaction(
    Aba::Transaction.new(
      :bsb => "342-342", 
      :account_number => "3244654", 
      :amount => 100.00, 
      :account_name => "John Doe", 
      :transaction_code => 53,
      :lodgement_reference => "R435564", 
      :trace_bsb => "453-543", 
      :trace_account_number => "45656733", 
      :name_of_remitter => "Remitter"
    )
  )
end

puts aba.to_s
```

## Installation

Add this line to your application's Gemfile:

    gem 'aba'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aba

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aba/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
