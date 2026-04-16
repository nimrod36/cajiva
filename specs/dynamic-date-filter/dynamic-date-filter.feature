Feature: Dynamic Date Range Filtering
  Users can dynamically filter the visible data on a chart by selecting a date range within the available data.
  This allows users to focus on specific time periods and revert to viewing all data as needed.

  Background:
    Given the chart displays data within a predefined available date range
    And the user has access to the filtering controls

  Rule: Filtering must be limited to the available date range
    Scenario: User selects a valid date range within the available data
      When the user selects a start date and an end date within the available range
      Then the chart updates to display data for the selected date range
      And the visible range reflects the selected date range

    Scenario: User selects a date range with no data available
      When the user selects a start date and an end date with no data in the range
      Then the chart updates to display an empty state
      And the message "No data available" is shown

  Rule: The filter must be reversible
    Scenario: User resets the date filter
      Given the chart displays data for a filtered date range
      When the user removes the active date filter
      Then the chart reverts to displaying all available data
      And the visible date range reflects the full dataset

  Rule: Invalid input must be handled gracefully
    Scenario: User selects a start date after the end date
      When the user selects a start date that is later than the end date
      Then the system prevents the action
      And an error message "Invalid date" is displayed

  Rule: Boundary conditions must be supported
    Scenario: User selects the smallest possible date range
      When the user selects a start date and an end date that span a single day
      Then the chart updates to display data for the selected day
