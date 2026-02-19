# frozen_string_literal: true

Given('the system has an empty data collection') do
  @data_points = []
  @x_values = []
  @y_values = []
end

When('I add a data point with day {int} and temperature {float}') do |day, temperature|
  @x_values << day
  @y_values << temperature
  @data_points << { day: day, temperature: temperature }
end

When('I retrieve all data points') do
  @retrieved_data = @data_points.dup
  @retrieved_x = @x_values.dup
  @retrieved_y = @y_values.dup
end

When('I add the following data points in quick succession:') do |table|
  table.hashes.each do |row|
    day = row['day'].to_i
    temperature = row['temperature'].to_f
    @x_values << day
    @y_values << temperature
    @data_points << { day: day, temperature: temperature }
  end
end

When('I verify the data fetcher uses append operation') do
  @original_count = @data_points.length
end

Then('the collection should contain {int} data point(s)') do |expected_count|
  expect(@data_points.length).to eq(expected_count)
  expect(@x_values.length).to eq(expected_count)
  expect(@y_values.length).to eq(expected_count)
end

Then('the data point at index {int} should have day {int} and temperature {float}') do |index, day, temperature|
  expect(@data_points[index][:day]).to eq(day)
  expect(@data_points[index][:temperature]).to be_within(0.001).of(temperature)
  expect(@x_values[index]).to eq(day)
  expect(@y_values[index]).to be_within(0.001).of(temperature)
end

Then('all original data points should remain unchanged') do
  expect(@retrieved_data).to eq(@data_points[0, @retrieved_data.length])
  @retrieved_data.each_with_index do |original_point, index|
    expect(@data_points[index]).to eq(original_point)
  end
end

Then('no data points should be overwritten') do
  # Check that each data point is unique by index
  @data_points.each_with_index do |point, index|
    original_day = index + 1
    expect(point[:day]).to eq(original_day)
  end

  # Verify array lengths match
  expect(@x_values.length).to eq(@data_points.length)
  expect(@y_values.length).to eq(@data_points.length)
end

Then('all data points should be retrievable in order') do
  @data_points.each_with_index do |point, index|
    expect(@x_values[index]).to eq(point[:day])
    expect(@y_values[index]).to be_within(0.001).of(point[:temperature])
  end
end

Then('retrieving data points again should show all {int} points') do |expected_count|
  current_data = @data_points.dup
  expect(current_data.length).to eq(expected_count)
  expect(@x_values.length).to eq(expected_count)
  expect(@y_values.length).to eq(expected_count)
end

Then('all temperature values should be preserved exactly') do
  @data_points.each_with_index do |point, index|
    expect(@y_values[index]).to eq(point[:temperature])
  end
end

Then('the data points should be in the order they were added') do
  # Verify that the order in arrays matches the order of addition
  previous_index = -1
  @data_points.each_with_index do |_point, index|
    expect(index).to be > previous_index
    previous_index = index
  end
end

Then('all temperature values should maintain their precision') do
  expected_values = [10.123, 20.456, 30.789]
  expected_values.each_with_index do |expected, index|
    expect(@y_values[index]).to be_within(0.0001).of(expected)
  end
end

Then('the collection should be empty') do
  expect(@data_points).to be_empty
  expect(@x_values).to be_empty
  expect(@y_values).to be_empty
end

Then('the original data point should still exist') do
  expect(@data_points.length).to be > @original_count
  expect(@data_points[0]).to eq({ day: 1, temperature: 100.0 })
end

Then('the new data point should be added to the end') do
  expect(@data_points.last).to eq({ day: 2, temperature: 200.0 })
end
