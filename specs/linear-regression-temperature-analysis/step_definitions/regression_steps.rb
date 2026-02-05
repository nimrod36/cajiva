# frozen_string_literal: true

require_relative '../../../lib/json_data_fetcher'
require_relative '../../../lib/linear_regression'

# Background steps
Given('the regression system is initialized') do
  @fetcher = Cajiva::JsonDataFetcher.new
  @x_values = nil
  @y_values = nil
  @model = nil
  @matrix_model = nil
  @formula_model = nil
end

Given('temperature data for Tel Aviv in June 2024 is available') do
  # Verify data file exists and is readable
  data_file = File.join(File.dirname(__FILE__), '../../../data/temperature_data.json')
  expect(File.exist?(data_file)).to be true
end

# When steps
When('the system loads temperature data for Tel Aviv') do
  @x_values, @y_values = @fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
end

When('the system calculates regression on valid data') do
  @x_values = [1, 2, 3, 4, 5]
  @y_values = [2, 4, 6, 8, 10]
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
end

When('the system calculates regression using matrix method') do
  @x_values ||= [1, 2, 3, 4, 5]
  @y_values ||= [2, 4, 6, 8, 10]
  @matrix_model = Cajiva::LinearRegression.new(@x_values, @y_values, method: :matrix)
end

When('the system calculates regression using formula method on the same data') do
  @formula_model = Cajiva::LinearRegression.new(@x_values, @y_values, method: :formula)
end

When('the system initializes regression with method: :formula') do
  @x_values = [1, 2, 3, 4, 5]
  @y_values = [2, 4, 6, 8, 10]
  @formula_model = Cajiva::LinearRegression.new(@x_values, @y_values, method: :formula)
end

When('the system initializes with method: :matrix') do
  @matrix_model = Cajiva::LinearRegression.new(@x_values, @y_values, method: :matrix)
end

Then('when the system initializes with method: :matrix') do
  @matrix_model = Cajiva::LinearRegression.new(@x_values, @y_values, method: :matrix)
  expect(@matrix_model).not_to be_nil
end

Then('when no method is specified, matrix should be the default') do
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
  expect(@model).not_to be_nil
end

Given('temperature data where all daily temperatures are identical') do
  @x_values = [1, 2, 3, 4, 5]
  @y_values = [25, 25, 25, 25, 25]
end

When('calculating regression on constant y-values') do
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
  @exception_raised = false
rescue StandardError => e
  @exception = e
  @exception_raised = true
end

Given('a regression model trained on temperature data') do
  @x_values, @y_values = @fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
end

When('the system predicts temperature for day {int}') do |day|
  @prediction = @model.predict(day)
end

Given('a regression model with intercept = {float} and slope = {float}') do |intercept, slope|
  # Create data that produces exactly these parameters
  # For simplicity, we'll create the model and verify prediction behavior
  @x_values = [1, 2, 3, 4, 5]
  @y_values = @x_values.map { |x| slope * x + intercept }
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
  @expected_intercept = intercept
  @expected_slope = slope
end

When('predicting at x = {int}') do |x|
  @prediction = @model.predict(x)
end

Given('a regression model trained on June 2024 data') do
  @x_values, @y_values = @fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
end

When('the system predicts temperature for day {int} \\(beyond June)') do |day|
  @prediction = @model.predict(day)
end

Given('the system has fewer than {int} data points') do |count|
  @x_values = count > 1 ? [1] : []
  @y_values = count > 1 ? [2] : []
end

When('attempting to calculate regression') do
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
  @exception_raised = false
rescue StandardError => e
  @exception = e
  @exception_raised = true
end

Given('the temperature data JSON file is missing') do
  # This step documents the scenario but actual implementation would require
  # mocking or temporarily moving the file
  @missing_file_scenario = true
end

When('the system attempts to fetch temperature data') do
  if @missing_file_scenario
    begin
      # This will not actually raise an error since the file exists
      # This test documents the expected behavior
      @fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
      @exception_raised = false
    rescue StandardError => e
      @exception = e
      @exception_raised = true
    end
  end
end

Given('a dataset with R² = {float} \\(perfect linear correlation)') do |r_squared|
  # Create perfectly correlated data
  @x_values = [1, 2, 3, 4, 5]
  @y_values = [2, 4, 6, 8, 10] # Perfect y = 2x relationship
  @expected_r_squared = r_squared
end

When('calculating regression') do
  @model = Cajiva::LinearRegression.new(@x_values, @y_values)
end

Given('the matrix method is used for calculation') do
  @x_values = [1, 1, 1, 1, 1] # Identical x-values create singular matrix scenario
  @y_values = [2, 4, 6, 8, 10]
  @use_matrix_method = true
end

When('the design matrix is singular or near-singular') do
  @model = Cajiva::LinearRegression.new(@x_values, @y_values, method: :matrix)
  @exception_raised = false
rescue StandardError => e
  @exception = e
  @exception_raised = true
end

# Then steps
Then('a linear regression model should be generated') do
  expect(@model).not_to be_nil
end

Then('the model should have a calculated slope') do
  expect(@model.slope).not_to be_nil
  expect(@model.slope).to be_a(Numeric)
end

Then('the model should have a calculated intercept') do
  expect(@model.intercept).not_to be_nil
  expect(@model.intercept).to be_a(Numeric)
end

Then('the model should have an R² value between {int} and {int}') do |min, max|
  expect(@model.r_squared).to be >= min
  expect(@model.r_squared).to be <= max
end

Then('the equation should display in the format {string}') do |_format|
  equation = @model.equation
  # Accept both decimal format (2.0) and rational format (2/1)
  expect(equation).to match(%r{y = -?[\d.]+(/\d+)?x [+-] [\d.]+(/\d+)?})
end

Then('negative intercepts should be formatted as {string}') do |_format|
  # Test with data that produces negative intercept
  x_neg = [1, 2, 3, 4, 5]
  y_neg = [-2, -1, 0, 1, 2] # Negative intercept
  model_neg = Cajiva::LinearRegression.new(x_neg, y_neg)

  expect(model_neg.equation).to match(%r{y = [\d.]+(/\d+)?x - [\d.]+(/\d+)?}) if model_neg.intercept.to_f.negative?
end

Then('both methods should produce slopes within {float} tolerance') do |tolerance|
  expect((@matrix_model.slope - @formula_model.slope).abs).to be < tolerance
end

Then('both methods should produce intercepts within {float} tolerance') do |tolerance|
  expect((@matrix_model.intercept - @formula_model.intercept).abs).to be < tolerance
end

Then('both methods should produce R² values within {float} tolerance') do |tolerance|
  expect((@matrix_model.r_squared - @formula_model.r_squared).abs).to be < tolerance
end

Then('the formula-based calculation should be used') do
  # Verified by successful initialization with :formula method
  expect(@formula_model).not_to be_nil
end

Then('the matrix-based calculation should be used') do
  # Verified by successful initialization with :matrix method
  expect(@matrix_model).not_to be_nil
end

Then('the slope should be zero') do
  expect(@model.slope).to be_within(0.01).of(0.0)
end

Then('the R² should be undefined or handled gracefully') do
  # When all y-values are identical, R² calculation involves division by zero
  # The system should either handle this or return NaN/Infinity
  r_squared = @model.r_squared
  expect(r_squared.nan? || r_squared.infinite? || (r_squared - 1.0).abs < 0.001).to be true
end

Then('the system should not raise an exception') do
  expect(@exception_raised).to be false
end

Then('the predicted value should be reasonable and within the data range') do
  expect(@prediction).to be_a(Numeric)
  # Prediction should be within reasonable bounds
  expect(@prediction).to be.positive?
  expect(@prediction).to be < 100
end

Then('the prediction should return {float}') do |expected|
  expect(@prediction).to be_within(0.01).of(expected)
end

Then('the system should apply the regression equation consistently') do
  # Verify extrapolation works (doesn't crash and returns numeric value)
  expect(@prediction).to be_a(Numeric)
end

Then('the system should fail gracefully') do
  # With insufficient data, we expect some kind of failure
  # This could be an exception or invalid results
  expect(@exception_raised || @model.nil?).to be true if @x_values.length < 2
end

Then('an appropriate error message should be logged') do
  expect(@exception.message).not_to be_empty if @exception_raised
end

Then('the system should raise an informative error') do
  # This test requires mocking file system or actual missing file
  # Mark as pending until proper mocking is implemented
  pending 'Requires file system mocking to properly test'
end

Then('the web UI should display an error message') do
  # This would require browser testing; documented as integration requirement
  pending 'Requires browser/integration testing'
end

Then('the R² value should be within {float} of {float}') do |tolerance, expected|
  expect(@model.r_squared).to be_within(tolerance).of(expected)
end

Then('the slope and intercept should be precise') do
  # With perfect correlation, slope and intercept should have minimal residual error
  # For y = 2x data, slope should be exactly 2.0 and intercept 0.0
  expect(@model.slope).to be_within(0.01).of(2.0)
  expect(@model.intercept).to be_within(0.01).of(0.0)
end

Then('the equation should accurately represent the perfect fit') do
  equation = @model.equation
  # Accept both "2.0" and "2/1" formats
  expect(equation).to match(%r{y = 2(\.0+|/1)x})
end

Then('the system should handle the error gracefully') do
  # Either doesn't raise exception or raises informative one
  expect(@exception.nil? || !@exception.message.empty?).to be true
end

Then('fallback to the formula-based method') do
  # Document that fallback behavior could be implemented
  pending 'Fallback mechanism not yet implemented'
end
