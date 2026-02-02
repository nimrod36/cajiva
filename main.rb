#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/version'

puts "🔧 Cajiva v#{Cajiva::VERSION}"
puts 'DevOps CI/CD Pipeline Manager'
puts ''
puts 'Available commands:'
puts '  rspec        - Run tests'
puts '  rubocop      - Run linter'
puts ''
puts 'Git hooks are configured for:'
puts '  pre-commit   - Auto-run tests and linting'
puts '  pre-push     - Auto-run full test suite'
