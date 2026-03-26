Feature: Update regression line upon new data insertion

  As a data analyst,
  I want the system to automatically recalculate and update the regression line whenever new data is inserted,
  So that the analysis remains accurate and up-to-date.

  Background:
    Given the regression analysis service is initialized
    And the system contains an existing dataset with a calculated regression line

  Scenario: Recalculate regression line after valid data insertion
    When a new valid data point is inserted into the system
    Then the system should recalculate the regression line
    And the updated regression line should correctly reflect the new dataset

  Scenario: Handle insertion of duplicate data
    When a duplicate data point is inserted into the system
    Then the system should not modify the regression line
    And a message should indicate that the data point was not added due to duplication

  Scenario: Handle insertion of invalid data
    When an invalid data point (e.g., non-numeric or null values) is inserted into the system
    Then the system should reject the data point
    And the regression line should remain unchanged
    And a message should indicate the reason for rejection

  Scenario: Handle insertion of multiple valid data points
    When multiple valid data points are inserted into the system at once
    Then the system should recalculate the regression line
    And the updated regression line should correctly reflect the new dataset

  Scenario: Handle partial failure during bulk data insertion
    Given a batch of data points contains both valid and invalid entries
    When the batch is inserted into the system
    Then the system should add only the valid data points
    And the regression line should be recalculated based on the valid data points
    And a message should indicate which data points were rejected and why

  Scenario: Handle edge case of empty dataset
    Given the system has an empty dataset
    When a new valid data point is inserted into the system
    Then the system should calculate the regression line using the single data point
    And the regression line should reflect the properties of a single-point dataset

  Scenario: Handle edge case of single data point dataset
    Given the system contains a single data point
    When a new valid data point is inserted into the system
    Then the system should calculate the regression line using the two data points
    And the regression line should pass through both points

  Scenario: Ensure idempotency of regression line calculation
    Given a dataset with an existing regression line
    When the same data points are recalculated multiple times
    Then the regression line should remain consistent across recalculations

  Scenario: Ensure performance for large data insertions
    Given the system contains a large dataset
    When 10,000 new valid data points are inserted into the system
    Then the system should recalculate the regression line within acceptable performance limits

  Scenario: Verify regression line accuracy
    Given the system contains a specific dataset
    When a new valid data point is inserted into the system
    Then the updated regression line should match the expected result based on the new dataset

  Scenario: Handle concurrent data insertions
    Given multiple users are inserting new data points simultaneously
    When each user inserts a valid data point
    Then the system should correctly handle all insertions without errors
    And the final regression line should reflect all successfully inserted data points in the correct order

  Scenario: Ensure audit log for data insertions and recalculations
    When a new valid data point is inserted into the system
    Then the system should log the data insertion event
    And the system should log the recalculation of the regression line
    And the logs should include a timestamp and details of the changes made