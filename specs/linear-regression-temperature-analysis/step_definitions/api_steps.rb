# frozen_string_literal: true

require 'rack/test'
require 'json'
require_relative '../../../app'

# Include Rack::Test::Methods for API testing
World(Rack::Test::Methods)

def app
  Sinatra::Application
end

# API Testing Steps
When('a client requests the regression data endpoint') do
  get '/api/data'
  @last_response = last_response
end

Then('the API should return a JSON response') do
  expect(@last_response.status).to eq(200)
  expect(@last_response.content_type).to include('application/json')
  @response_data = JSON.parse(@last_response.body)
end

Then('the response should include actual data points') do
  expect(@response_data).to have_key('actual')
  expect(@response_data['actual']).to be_an(Array)
  expect(@response_data['actual']).not_to be_empty
end

Then('the response should include regression line points') do
  expect(@response_data).to have_key('regression')
  expect(@response_data['regression']).to be_an(Array)
  expect(@response_data['regression']).not_to be_empty
end

Then('the response should include the regression equation') do
  expect(@response_data).to have_key('equation')
  expect(@response_data['equation']).to be_a(String)
  expect(@response_data['equation']).to match(/y = .+x [+-] .+/)
end

Then('the response should include the R² value') do
  expect(@response_data).to have_key('r_squared')
  expect(@response_data['r_squared']).to be_a(Numeric)
end

Then('the response should include slope and intercept values') do
  expect(@response_data).to have_key('slope')
  expect(@response_data).to have_key('intercept')
  expect(@response_data['slope']).to be_a(Numeric)
  expect(@response_data['intercept']).to be_a(Numeric)
end

When('the API returns temperature data') do
  get '/api/data'
  @response_data = JSON.parse(last_response.body)
end

Then('actual data point y-values should be rounded to {int} decimal places') do |decimal_places|
  @response_data['actual'].each do |point|
    y_value = point['y']
    # Check that the value has at most the specified decimal places
    expect(y_value.to_s.split('.').last.length).to be <= decimal_places
  end
end

Then('regression line predictions should be rounded to {int} decimal places') do |decimal_places|
  @response_data['regression'].each do |point|
    y_value = point['y']
    expect(y_value.to_s.split('.').last.length).to be <= decimal_places
  end
end

Then('slope\\/intercept in the response should be rounded to {int} decimal places') do |decimal_places|
  slope_decimals = @response_data['slope'].to_s.split('.').last.length
  intercept_decimals = @response_data['intercept'].to_s.split('.').last.length

  expect(slope_decimals).to be <= decimal_places
  expect(intercept_decimals).to be <= decimal_places
end

# Web UI Testing Steps
When('the user accesses the Cajiva web interface') do
  get '/'
  @last_response = last_response
end

Then('the page should load successfully') do
  expect(@last_response.status).to eq(200)
  expect(@last_response.body).to include('html')
end

Then('the API data endpoint should be called') do
  # Verify the HTML references the API endpoint
  expect(@last_response.body).to include('/api/data')
end

Then('Chart.js visualization should display temperature scatter plot') do
  # Verify Chart.js is referenced in the HTML
  expect(@last_response.body).to match(/chart\.js|Chart/)
end

Then('the regression line should be overlaid on the chart') do
  # This would require browser testing to fully verify
  # For now, verify the HTML structure includes chart elements
  pending 'Requires browser/JavaScript testing'
end

Then('statistics should display on the page') do
  # This would require browser testing to fully verify
  pending 'Requires browser/JavaScript testing'
end
