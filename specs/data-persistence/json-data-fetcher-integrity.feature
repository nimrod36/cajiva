Feature: JSON Data Fetcher Data Integrity
  As a developer
  I want the JsonDataFetcher to correctly append data points
  So that temperature data is not overwritten when adding new entries

  Background:
    Given a test JSON file with temperature data exists

  Scenario: Fetch existing temperature data without modification
    When I fetch temperature data for "TestCity" in January 2024
    Then the fetched data should contain the correct number of points
    And the x_values array should match the day sequence
    And the y_values array should match the temperature readings

  Scenario: Multiple fetches preserve data integrity
    When I fetch temperature data for "TestCity" in January 2024
    And I store the fetched data
    And I fetch temperature data for "TestCity" in January 2024 again
    Then the second fetch should return identical data to the first

  Scenario: Convert to arrays maintains pairing
    When I fetch temperature data for "TestCity" in January 2024
    Then each x_value should correspond to the correct y_value
    And the array lengths should be equal

  Scenario: Fetch returns arrays not single values
    When I fetch temperature data for "TestCity" in January 2024
    Then the result should be a two-element array
    And the first element should be an array of x_values
    And the second element should be an array of y_values

  Scenario: Data conversion preserves order
    When I fetch temperature data for "TestCity" in January 2024
    Then the x_values should be in sequential order
    And the y_values should correspond to the chronological temperature readings

  Scenario: Handle empty result set
    When I fetch temperature data for "NonexistentCity" in January 2024
    Then the result should contain empty arrays
    And the x_values array should be empty
    And the y_values array should be empty

  Scenario: Verify convert_to_arrays uses append operations
    When I fetch temperature data with 5 records
    Then the conversion should produce arrays of length 5
    And no data should be overwritten during conversion
    And each index should have corresponding x and y values
