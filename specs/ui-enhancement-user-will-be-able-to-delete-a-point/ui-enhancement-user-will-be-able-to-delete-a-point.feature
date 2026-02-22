Feature: Delete a data point from the chart
  As a user
  I want to delete a data point from the chart on mouse over
  So that I can remove incorrect or unnecessary data points easily

  Background:
    Given a chart is displayed with multiple data points
    And the user has permissions to modify the chart

  Scenario: Successfully delete a data point on mouse over
    Given the chart is displayed with data points
    And the user hovers over a data point
    When the user clicks the delete icon on the hovered data point
    Then the data point is removed from the chart
    And the chart updates to reflect the change
    And the user sees a confirmation message "Data point deleted successfully"

  Scenario: Attempt to delete a data point without hovering
    Given the chart is displayed with data points
    When the user clicks in the chart area without hovering over a data point
    Then no data point is deleted
    And the delete action is not triggered

  Scenario: Attempt to delete a data point when the action is disabled
    Given the chart is displayed with data points
    And the delete functionality is disabled
    When the user hovers over a data point and clicks the delete icon
    Then the data point is not removed from the chart
    And the user sees an error message "Delete action is currently disabled"

  Scenario: Hover over a data point and cancel the delete action
    Given the chart is displayed with data points
    And the user hovers over a data point
    When the user clicks outside the delete icon without clicking the icon
    Then no data point is deleted
    And the chart remains unchanged

  Scenario: Attempt to delete a data point when the chart contains no points
    Given the chart is displayed and contains no data points
    When the user hovers over the chart area
    Then no delete icon is displayed
    And no delete action is possible

  Scenario Outline: Delete multiple data points from the chart
    Given the chart is displayed with data points
    And the user hovers over a data point labeled <dataPoint>
    When the user clicks the delete icon
    Then the data point <dataPoint> is removed from the chart
    And the chart updates to reflect the change

    Examples:
      | dataPoint   |
      | Point A     |
      | Point B     |
      | Point C     |

  Scenario: Undo a delete action
    Given the chart is displayed with data points
    And the user deletes a data point
    When the user clicks the "Undo" button
    Then the deleted data point is restored to the chart
    And the chart updates to reflect the restoration

  Scenario: Delete a data point and observe audit log entry
    Given the chart is displayed with data points
    And the user hovers over a data point
    When the user clicks the delete icon
    Then the data point is removed from the chart
    And an entry "Data point deleted: <dataPoint>" is added to the audit log

  Scenario: Attempt to delete a data point with network connectivity issues
    Given the chart is displayed with data points
    And the user hovers over a data point
    When the user clicks the delete icon
    And there is a network connectivity issue
    Then the data point is not removed from the chart
    And the user sees an error message "Unable to delete data point, please try again later"

  Scenario: Delete a data point and verify chart recalculations
    Given the chart is displayed with data points
    And the chart includes calculated values based on data points
    When the user deletes a data point
    Then the chart recalculates the values excluding the deleted data point
    And the updated calculation is displayed correctly