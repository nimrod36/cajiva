# frozen_string_literal: true

require_relative '../../../lib/json_data_fetcher'
require 'json'
require 'tempfile'

Given('a test JSON file with temperature data exists') do
  @test_data = {
    'temperature_readings' => [
      { 'date' => '2024-01-01', 'city' => 'TestCity', 'hour' => 12, 'temperature' => 15.5 },
      { 'date' => '2024-01-02', 'city' => 'TestCity', 'hour' => 12, 'temperature' => 16.2 },
      { 'date' => '2024-01-03', 'city' => 'TestCity', 'hour' => 12, 'temperature' => 14.8 },
      { 'date' => '2024-01-04', 'city' => 'TestCity', 'hour' => 12, 'temperature' => 17.3 },
      { 'date' => '2024-01-05', 'city' => 'TestCity', 'hour' => 12, 'temperature' => 18.1 }
    ]
  }

  # Create temp file in data directory
  @test_file_path = File.join(File.dirname(__FILE__), '../../../data/test_temperature_data.json')
  File.write(@test_file_path, @test_data.to_json)

  @fetcher = Cajiva::JsonDataFetcher.new('data/test_temperature_data.json')
end

When('I fetch temperature data for {string} in January {int}') do |city, year|
  @fetched_data = @fetcher.fetch_temperature_data(city, 1, year)
  @x_values = @fetched_data[0]
  @y_values = @fetched_data[1]
end

When('I store the fetched data') do
  @stored_data = @fetched_data.dup
  @stored_x = @x_values.dup
  @stored_y = @y_values.dup
end

When('I fetch temperature data for {string} in January {int} again') do |city, year|
  @second_fetch = @fetcher.fetch_temperature_data(city, 1, year)
  @second_x = @second_fetch[0]
  @second_y = @second_fetch[1]
end

When('I fetch temperature data with {int} records') do |record_count|
  # Use the existing test data which has 5 records
  @fetched_data = @fetcher.fetch_temperature_data('TestCity', 1, 2024)
  @x_values = @fetched_data[0]
  @y_values = @fetched_data[1]
  expect(@x_values.length).to eq(record_count)
end

Then('the fetched data should contain the correct number of points') do
  expect(@x_values.length).to eq(5)
  expect(@y_values.length).to eq(5)
end

Then('the x_values array should match the day sequence') do
  expected_days = [1, 2, 3, 4, 5]
  expect(@x_values).to eq(expected_days)
end

Then('the y_values array should match the temperature readings') do
  expected_temps = [15.5, 16.2, 14.8, 17.3, 18.1]
  @y_values.each_with_index do |temp, index|
    expect(temp).to be_within(0.01).of(expected_temps[index])
  end
end

Then('the second fetch should return identical data to the first') do
  expect(@second_x).to eq(@stored_x)
  expect(@second_y).to eq(@stored_y)
end

Then('each x_value should correspond to the correct y_value') do
  @x_values.each_with_index do |day, index|
    expect(day).to eq(index + 1)
    expect(@y_values[index]).to be_a(Float)
  end
end

Then('the array lengths should be equal') do
  expect(@x_values.length).to eq(@y_values.length)
end

Then('the result should be a two-element array') do
  expect(@fetched_data).to be_a(Array)
  expect(@fetched_data.length).to eq(2)
end

Then('the first element should be an array of x_values') do
  expect(@fetched_data[0]).to be_a(Array)
  expect(@fetched_data[0]).to eq(@x_values)
end

Then('the second element should be an array of y_values') do
  expect(@fetched_data[1]).to be_a(Array)
  expect(@fetched_data[1]).to eq(@y_values)
end

Then('the x_values should be in sequential order') do
  @x_values.each_with_index do |day, index|
    expect(day).to eq(index + 1)
  end
end

Then('the y_values should correspond to the chronological temperature readings') do
  # Verify that y_values maintain their original order from the JSON
  expected_temps = [15.5, 16.2, 14.8, 17.3, 18.1]
  expect(@y_values).to eq(expected_temps)
end

Then('the result should contain empty arrays') do
  expect(@fetched_data).to eq([[], []])
end

Then('the x_values array should be empty') do
  expect(@x_values).to be_empty
end

Then('the y_values array should be empty') do
  expect(@y_values).to be_empty
end

Then('the conversion should produce arrays of length {int}') do |expected_length|
  expect(@x_values.length).to eq(expected_length)
  expect(@y_values.length).to eq(expected_length)
end

Then('no data should be overwritten during conversion') do
  # Verify each element is unique and in sequence
  @x_values.each_with_index do |x_val, index|
    expect(x_val).to eq(index + 1)
  end

  # Verify all temperatures are present
  expected_temps = [15.5, 16.2, 14.8, 17.3, 18.1]
  expect(@y_values).to eq(expected_temps)
end

Then('each index should have corresponding x and y values') do
  @x_values.length.times do |index|
    expect(@x_values[index]).to be_a(Integer)
    expect(@y_values[index]).to be_a(Float)
    expect(@x_values[index]).to eq(index + 1)
  end
end

After do
  File.delete(@test_file_path) if @test_file_path && File.exist?(@test_file_path)
end
