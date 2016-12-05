require 'bundler/setup'
require 'codebreaker_gem'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end
