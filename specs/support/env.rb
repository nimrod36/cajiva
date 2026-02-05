# frozen_string_literal: true

require 'rspec/expectations'
require 'rack/test'

# Include RSpec matchers for Cucumber steps
World(RSpec::Matchers)

# Set up environment
ENV['RACK_ENV'] = 'test'
