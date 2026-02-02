#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/version'
require_relative 'lib/json_data_fetcher'
require_relative 'lib/linear_regression'

puts "📊 Cajiva v#{Cajiva::VERSION}"
puts 'Linear Regression Analysis Tool'
puts ''
puts 'Features:'
puts '  - Analyze temperature data from JSON'
puts '  - Fit linear regression models (matrix or formula)'
puts '  - Calculate R² values'
puts '  - Make predictions'
puts ''

# Example usage
fetcher = Cajiva::JsonDataFetcher.new
x, y = fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
p y
p '%%%%%%%%%%%%'
p x

model = Cajiva::LinearRegression.new(x, y)

puts 'Example: Tel Aviv June 2024 Temperature Analysis'
puts "Data points: #{x.length}"
puts "Regression equation: #{model.equation}"
puts "R² value: #{model.r_squared.round(4)}"
puts ''
puts 'Temperature trend:'
puts "  Day 1: #{model.predict(1).round(2)}°C"
puts "  Day 15: #{model.predict(15).round(2)}°C"
puts "  Day 30: #{model.predict(30).round(2)}°C"
