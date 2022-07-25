# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require "aba"
require "pry"

RSpec.configure do |config|
  config.order = :random
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
