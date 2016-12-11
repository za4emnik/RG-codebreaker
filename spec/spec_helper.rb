require 'bundler/setup'
require 'codebreaker_gem'

RSpec.configure do |config|
  #config.filter_run :focus => true
  config.color = true
  config.formatter = :documentation
end

RSpec::Matchers.define :have_attr_reader do |field|
  match do |object_instance|
    object_instance.respond_to?(field)
  end

  failure_message do |object_instance|
    "expected attr_reader for #{field} on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected attr_reader for #{field} not to be defined on #{object_instance}"
  end

  description do
    "checks to see if there is an attr reader on the supplied object"
  end
end

RSpec::Matchers.define :have_attr_accessor do |field|
  match do |object_instance|
    object_instance.respond_to?("#{field}=") &&
    object_instance.respond_to?(field)
  end

  failure_message do |object_instance|
    "expected have_attr_accessor for #{field} on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected have_attr_accessor for #{field} not to be defined on #{object_instance}"
  end

  description do
    "checks to see if there is an attr accessor on the supplied object"
  end
end
