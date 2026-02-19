Feature: Data Point Persistence and Integrity
  As a user of the temperature analysis system
  I want to add multiple data points without losing existing data
  So that I can build a complete dataset for accurate analysis

  Background:
    Given the system has an empty data collection

  Scenario: Add single data point to empty dataset
    When I add a data point with day 1 and temperature 10
    Then the collection should contain 1 data point
    And the data point at index 0 should have day 1 and temperature 10

  Scenario: Add multiple sequential data points
    When I add a data point with day 1 and temperature 10
    And I add a data point with day 2 and temperature 20
    And I add a data point with day 3 and temperature 30
    Then the collection should contain 3 data points
    And the data point at index 0 should have day 1 and temperature 10
    And the data point at index 1 should have day 2 and temperature 20
    And the data point at index 2 should have day 3 and temperature 30

  Scenario: Add data point with duplicate day value
    Given I add a data point with day 5 and temperature 50
    When I add a data point with day 5 and temperature 75
    Then the collection should contain 2 data points
    And the data point at index 0 should have day 5 and temperature 50
    And the data point at index 1 should have day 5 and temperature 75

  Scenario: Data persistence across multiple operations
    When I add a data point with day 1 and temperature 15
    And I add a data point with day 2 and temperature 18
    And I retrieve all data points
    And I add a data point with day 3 and temperature 22
    Then the collection should contain 3 data points
    And all original data points should remain unchanged

  Scenario: Rapid sequential additions
    When I add the following data points in quick succession:
      | day | temperature |
      | 1   | 10.5        |
      | 2   | 12.3        |
      | 3   | 14.8        |
      | 4   | 16.2        |
      | 5   | 18.9        |
    Then the collection should contain 5 data points
    And no data points should be overwritten
    And all data points should be retrievable in order

  Scenario: Verify data integrity after retrieval
    Given I add a data point with day 1 and temperature 20
    And I add a data point with day 2 and temperature 25
    When I retrieve all data points
    And I add a data point with day 3 and temperature 30
    Then the collection should contain 3 data points
    And retrieving data points again should show all 3 points

  Scenario: Add data points with extreme values
    When I add a data point with day 1 and temperature -40
    And I add a data point with day 2 and temperature 50
    And I add a data point with day 3 and temperature 0
    Then the collection should contain 3 data points
    And all temperature values should be preserved exactly

  Scenario Outline: Sequential additions maintain order
    When I add a data point with day <day1> and temperature <temp1>
    And I add a data point with day <day2> and temperature <temp2>
    And I add a data point with day <day3> and temperature <temp3>
    Then the collection should contain 3 data points
    And the data points should be in the order they were added

    Examples:
      | day1 | temp1 | day2 | temp2 | day3 | temp3 |
      | 1    | 10    | 2    | 20    | 3    | 30    |
      | 5    | 25    | 3    | 15    | 7    | 35    |
      | 10   | 5     | 11   | 6     | 12   | 7     |

  Scenario: Handle decimal precision in temperature values
    When I add a data point with day 1 and temperature 10.123
    And I add a data point with day 2 and temperature 20.456
    And I add a data point with day 3 and temperature 30.789
    Then the collection should contain 3 data points
    And all temperature values should maintain their precision

  Scenario: Empty dataset validation
    When I retrieve all data points
    Then the collection should contain 0 data points
    And the collection should be empty

  Scenario: Verify append operation not replace
    Given I add a data point with day 1 and temperature 100
    When I verify the data fetcher uses append operation
    And I add a data point with day 2 and temperature 200
    Then the original data point should still exist
    And the new data point should be added to the end
