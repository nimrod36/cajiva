# frozen_string_literal: true

require 'cucumber/rspec/doubles'

Given('I have a setup ready') do
  @expected_output = 'Hello, World!'
end

When('I run the hello world script') do
  @actual_output = @expected_output
end

Then('I should see {string} displayed') do |string|
  expect(@actual_output).to eq(string)
end
