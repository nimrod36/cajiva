Feature: Linear Regression Temperature Analysis
  As a data analyst
  I want to perform linear regression on temperature data
  So that I can understand temperature trends and make predictions

  Background:
    Given the regression system is initialized
    And temperature data for Tel Aviv in June 2024 is available

  Rule: Regression Model Calculation

    Scenario: Calculate regression model with valid temperature data
      When the system loads temperature data for Tel Aviv
      Then a linear regression model should be generated
      And the model should have a calculated slope
      And the model should have a calculated intercept
      And the model should have an R² value between 0 and 1

    Scenario: Generate correct regression equation format
      When the system calculates regression on valid data
      Then the equation should display in the format "y = [slope]x [sign] [intercept]"
      And negative intercepts should be formatted as "y = [slope]x - [value]"

    Scenario: Both calculation methods produce identical results
      When the system calculates regression using matrix method
      And the system calculates regression using formula method on the same data
      Then both methods should produce slopes within 0.01 tolerance
      And both methods should produce intercepts within 0.01 tolerance
      And both methods should produce R² values within 0.01 tolerance

    Scenario: Support custom regression method selection
      When the system initializes regression with method: :formula
      Then the formula-based calculation should be used
      And when the system initializes with method: :matrix
      Then the matrix-based calculation should be used
      And when no method is specified, matrix should be the default

    Scenario: Handle identically-valued y-data (zero variance)
      Given temperature data where all daily temperatures are identical
      When calculating regression on constant y-values
      Then the slope should be zero
      And the R² should be undefined or handled gracefully
      And the system should not raise an exception

  Rule: Prediction and Extrapolation

    Scenario: Predict temperature for a day within data range
      Given a regression model trained on temperature data
      When the system predicts temperature for day 15
      Then the predicted value should be reasonable and within the data range

    Scenario: Verify prediction at intercept point (x=0)
      Given a regression model with intercept = 5.0 and slope = 2.0
      When predicting at x = 0
      Then the prediction should return 5.0

    Scenario: Extrapolate temperature beyond data range
      Given a regression model trained on June 2024 data
      When the system predicts temperature for day 60 (beyond June)
      Then the system should apply the regression equation consistently

  Rule: Web API Service

    Scenario: API returns complete regression analysis
      When a client requests the regression data endpoint
      Then the API should return a JSON response
      And the response should include actual data points
      And the response should include regression line points
      And the response should include the regression equation
      And the response should include the R² value
      And the response should include slope and intercept values

    Scenario: Ensure API response data points match expected precision
      When the API returns temperature data
      Then actual data point y-values should be rounded to 2 decimal places
      And regression line predictions should be rounded to 2 decimal places
      And slope/intercept in the response should be rounded to 4 decimal places

    Scenario: Web UI renders visualization from API data
      When the user accesses the Cajiva web interface
      Then the page should load successfully
      And the API data endpoint should be called
      And Chart.js visualization should display temperature scatter plot
      And the regression line should be overlaid on the chart
      And statistics should display on the page

    Scenario: Web UI provides inputs to add a new data point
      When the user accesses the Cajiva web interface
      Then the add data point form should be available

    Scenario: User adds a new data point in the UI
      When the user accesses the Cajiva web interface
      And the user provides a day and temperature
      And the user adds the data point
      Then the new data point should appear in the list
      And the data points count should increase
      And the chart should include the new point

    Scenario: User removes an added data point
      Given the user has added a new data point
      When the user removes the data point
      Then the new data point should be removed from the list
      And the data points count should decrease

    Scenario: Recalculate regression requires at least one new point
      When the user attempts to recalculate without new points
      Then the UI should show a validation message

    Scenario: API recalculates regression with user-provided data
      Given a set of new data points provided by the user
      When a client posts the data to the recalculation endpoint
      Then the API should return a JSON response
      And the response should include actual data points
      And the response should include regression line points
      And the response should include the regression equation
      And the response should include the R² value
      And the response should include slope and intercept values
      And the recalculated data should include the new points

  Rule: Error Handling and Edge Cases

    Scenario: Handle insufficient data for regression
      Given the system has fewer than 2 data points
      When attempting to calculate regression
      Then the system should fail gracefully
      And an appropriate error message should be logged

    Scenario: Handle JSON data source unavailability
      Given the temperature data JSON file is missing
      When the system attempts to fetch temperature data
      Then the system should raise an informative error
      And the web UI should display an error message

    Scenario: Regression produces correct R² for perfectly correlated data
      Given a dataset with R² = 1.0 (perfect linear correlation)
      When calculating regression
      Then the R² value should be within 0.01 of 1.0
      And the slope and intercept should be precise
      And the equation should accurately represent the perfect fit

    Scenario: Handle singular matrix in matrix calculation
      Given the matrix method is used for calculation
      When the design matrix is singular or near-singular
      Then the system should handle the error gracefully
