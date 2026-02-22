Feature: Delete a data point in the chart
  As a user
  I want to delete a data point in the chart by hovering over it
  So that I can remove unnecessary or incorrect data points

  Background:
    Given a chart is displayed with multiple data points
    And the user is logged in and has edit permissions for the chart

  Scenario: Successfully delete a data point (happy path)
    Given the chart contains multiple data points
    And the user hovers over a specific data point
    When the delete option is displayed
    And the user clicks on the delete option
    Then the data point is removed from the chart
    And the chart updates to reflect the change
    And a success message "Data point deleted successfully" is shown

  Scenario: Attempt to delete a data point without hovering
    Given the chart contains multiple data points
    When the user does not hover over any data point
    Then no delete option is displayed
    And no data point is deleted

  Scenario: Attempt to delete a non-existent data point
    Given the chart contains multiple data points
    When the user hovers over an area without a data point
    Then no delete option is displayed
    And no data point is deleted

  Scenario: Undo deletion of a data point
    Given the chart contains multiple data points
    And the user hovers over a specific data point
    And the delete option is displayed
    When the user clicks on the delete option
    And the data point is removed from the chart
    And the success message "Data point deleted successfully" is shown
    When the user clicks the "Undo" button
    Then the data point is restored to the chart
    And the chart updates to reflect the restoration

  Scenario: Deleting a data point without sufficient permissions
    Given the chart contains multiple data points
    And the user does not have edit permissions for the chart
    When the user hovers over a specific data point
    Then no delete option is displayed
    And the user is not allowed to delete the data point

  Scenario: Delete a data point and verify data integrity
    Given the chart contains multiple data points
    And the user hovers over a specific data point
    And the delete option is displayed
    When the user clicks on the delete option
    Then the data point is removed from the chart
    And the chart updates to reflect the change
    And the data set in the backend reflects the deletion

  Scenario: Delete a data point and test API failure
    Given the chart contains multiple data points
    And the user hovers over a specific data point
    And the delete option is displayed
    When the user clicks on the delete option
    And the API for deleting the data point fails
    Then the data point is not removed from the chart
    And an error message "Failed to delete data point. Please try again." is displayed

  Scenario Outline: Delete multiple data points
    Given the chart contains multiple data points
    And the user hovers over <data point>
    And the delete option is displayed
    When the user clicks on the delete option
    Then <data point> is removed from the chart
    And the chart updates to reflect the change

    Examples:
      | data point        |
      | the first data point |
      | the last data point  |
      | a middle data point  |