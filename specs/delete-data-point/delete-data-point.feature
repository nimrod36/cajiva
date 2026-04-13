Feature: Delete a data point
  As a user,
  I want to delete a specific data point
  So that I can maintain the accuracy of the data in the system.

  Background:
    Given the system is operational
    And the user is logged in
    And a data point exists in the current view

  Rule: Deleting a data point must be deliberate and confirmable
    Scenario: Deleting a data point successfully
      Given the user selects a data point
      When the user opens the deletion dialog
      And confirms the deletion
      Then the data point should be removed from the system
      And the data point should no longer be visible in the current view

    Scenario: Canceling the deletion process
      Given the user selects a data point
      When the user opens the deletion dialog
      And cancels the operation
      Then the data point should remain in the system
      And the data point should remain visible in the current view


  Rule: Accessibility
    Scenario: Keyboard navigation for deletion
      Given the user is navigating with a keyboard
      When the user selects a data point
      And opens the deletion dialog
      Then the user should be able to confirm or cancel deletion using the keyboard
