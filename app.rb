# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'lib/json_data_fetcher'
require_relative 'lib/linear_regression'

set :port, 4567
set :bind, '0.0.0.0'
set :public_folder, "#{File.dirname(__FILE__)}/public"

# API endpoint to get temperature data and regression
get '/api/data' do
  content_type :json

  fetcher = Cajiva::JsonDataFetcher.new
  x, y = fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
  model = Cajiva::LinearRegression.new(x, y)

  # Generate regression line points
  regression_line = x.map { |day| { x: day, y: model.predict(day).round(2) } }

  # Format actual data points
  actual_data = x.zip(y).map { |day, temp| { x: day, y: temp.round(2) } }

  {
    actual: actual_data,
    regression: regression_line,
    equation: model.equation,
    r_squared: model.r_squared.round(4),
    slope: model.slope.round(4),
    intercept: model.intercept.round(4)
  }.to_json
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end
