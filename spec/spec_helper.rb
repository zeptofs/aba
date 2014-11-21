require 'bundler/setup'
Bundler.setup

require "aba"

RSpec.configure do |config|
  config.order = :random
end
