Feature: User Profile Management
  As a registered user
  I want to view and edit my profile information
  So that I can manage my personal details and preferences

  Background:
    Given a registered user with the username "testuser" and email "testuser@example.com"
    And the user is logged into their account

  Scenario: View user profile
    Given the user navigates to the profile page
    When the profile page is loaded
    Then the user's name is displayed as "Test User"
    And the user's email is displayed as "testuser@example.com"
    And the user's preferences are displayed

  Scenario: Update user name
    Given the user is on the profile edit page
    When the user updates the name to "Updated User"
    And clicks the save button
    Then the profile is updated successfully
    And the updated name "Updated User" is displayed on the profile page

  Scenario: Update email address
    Given the user is on the profile edit page
    When the user updates the email address to "updateduser@example.com"
    And clicks the save button
    Then the profile is updated successfully
    And the updated email address "updateduser@example.com" is displayed on the profile page

  Scenario: Update preferences
    Given the user is on the profile edit page
    When the user updates their preferences to "Dark Mode"
    And clicks the save button
    Then the profile is updated successfully
    And the updated preferences "Dark Mode" are displayed on the profile page

  Scenario: Cancel profile update
    Given the user is on the profile edit page
    When the user updates the name to "Cancelled Name"
    And clicks the cancel button
    Then the profile changes are not saved
    And the name remains "Test User" on the profile page

  Scenario: Error handling for invalid email
    Given the user is on the profile edit page
    When the user updates the email address to "invalidemail"
    And clicks the save button
    Then an error message "Please enter a valid email address" is displayed
    And the email address remains unchanged as "testuser@example.com"

  Scenario: Error handling for empty name
    Given the user is on the profile edit page
    When the user clears the name field
    And clicks the save button
    Then an error message "Name cannot be empty" is displayed
    And the name remains unchanged as "Test User"

  Scenario: Simultaneous updates in multiple sessions
    Given the user is logged in from two different devices
    And the user updates their name to "Device1 Name" on the first device
    And the user updates their name to "Device2 Name" on the second device
    When the user refreshes the profile page on both devices
    Then the name is consistent and reflects the most recent update

  Scenario Outline: Data-driven profile updates
    Given the user is on the profile edit page
    When the user updates the <field> to "<value>"
    And clicks the save button
    Then the profile is updated successfully
    And the updated <field> "<value>" is displayed on the profile page

    Examples:
      | field      | value                    |
      | name       | New Name                 |
      | email      | newemail@example.com     |
      | preferences| Light Mode               |