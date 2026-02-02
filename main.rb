#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/version'
require_relative 'lib/database_connection'
require_relative 'lib/data_fetcher'
require_relative 'lib/linear_regression'

puts "📊 Cajiva v#{Cajiva::VERSION}"
puts 'Linear Regression Analysis Tool'
puts ''
puts 'Features:'
puts '  - Fetch temperature data from MySQL'
puts '  - Fit linear regression models'
puts '  - Calculate R² values'
puts '  - Make predictions'
puts ''
puts 'Usage:'
puts '  require_relative "main.rb"'
puts '  db = Cajiva::DatabaseConnection.new'
puts '  fetcher = Cajiva::DataFetcher.new(db)'
puts '  x, y = fetcher.fetch_temperature_data("Tel Aviv", 6, 2024)'
puts '  model = Cajiva::LinearRegression.new(x, y)'
puts '  puts model.equation'
puts '  puts "R² = " + model.r_squared.to_s'
