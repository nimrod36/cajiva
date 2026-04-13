Feature: Change background color
  As a user
  I want to customize the background color of the interface
  So that I can personalize my experience and revert changes if needed

  Background:
    Given the system has a default background color

  Scenario: User changes the background color successfully
    When the user selects a new background color
    Then the system should immediately update the background color
    And the change should not affect the layout or functionality

  Scenario: User reverts the background color to the previous selection
    Given the user has changed the background color
    When the user clicks the revert button
    Then the background color should return to the previous selection

  Scenario: User reverts to the default background color
    Given the user has not changed the background color
    When the user clicks the revert button
    Then the background color should remain as the default

