[ ![Codeship Status for krakendevelopments/aba](https://codeship.com/projects/982382f0-f22b-0132-a80d-0acc257ded9c/status?branch=master)](https://codeship.com/projects/85083)

# Aba

Generates ABA (Australian Banking Association) file format output

## Usage

```ruby
require 'aba'

# Initialise ABA
aba = Aba.new(
  bsb: "123-345", # Optional (Not required by NAB)
  financial_institution: "WPC",
  user_name: "John Doe",
  user_id: "466364",
  description: "Payroll",
  process_at: Time.now.strftime("%d%m%y")
)

# Add transactions
10.times do
  aba.add_transaction(
    {
      bsb: "342-342",
      account_number: "3244654",
      amount: 10000, # Amount in cents
      account_name: "John Doe",
      transaction_code: 53,
      lodgement_reference: "R435564",
      trace_bsb: "453-543",
      trace_account_number: "45656733",
      name_of_remitter: "Remitter"
    }
  )
end

puts aba.to_s # View output
File.write("/Users/me/dd_#{Time.now.to_i}.aba", aba.to_s) # or write output to file
```

Validation errors can be caught in several ways:

```ruby
# Create an ABA object with invalid character in the user_name
aba = Aba.new(
  financial_institution: "ANZ",
  user_name: "Jøhn Doe",
  user_id: "123456",
  process_at: Time.now.strftime("%d%m%y")
)


# Add a transaction with a bad BSB
aba.add_transaction(
  bsb: "abc-123",
  account_number: "000123456"
)


# Is the data valid?
aba.all_valid?

# Returns: false


# Return a structured array of errors
puts aba.all_errors

# Returns:
# {:aba => ["user_name must not contain invalid characters"],
#  :transactions =>
#   {0 => ["bsb format is incorrect", "trace_bsb format is incorrect"]}}
```

Validation errors will stop parsing of the data to an ABA formatted string using
`to_s`. `aba.to_s` will raise a `RuntimeError` instead of returning output.


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
