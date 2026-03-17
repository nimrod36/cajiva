Feature: Update UI Title from "Cajiva" to "Regression Tool"
  As a user
  I want the application title to display "Regression Tool"
  So that it correctly reflects the purpose of the application

  Background:
    Given the application is deployed
    And the user has access to the application

  Scenario: Verify UI title displays "Regression Tool" on the homepage
    Given the user opens the application homepage
    When the page is fully loaded
    Then the title should display "Regression Tool"

  Scenario: Verify the UI title is consistent across all pages
    Given the user navigates to different pages in the application
    When the page is fully loaded
    Then the title should display "Regression Tool"
    And the title should be consistent across all pages

  Scenario: Validate the UI title does not display the old name
    Given the user opens the application homepage
    When the page is fully loaded
    Then the title should not display "Cajiva"

  Scenario: Verify UI title with different screen resolutions
    Given the user opens the application on a <screen size> resolution device
    When the page is fully loaded
    Then the title should display "Regression Tool"
    
    Examples:
      | screen size  |
      | 1920x1080    |
      | 1366x768     |
      | 1024x768     |
      | 320x568      |

  Scenario: Verify UI title for accessibility standards
    Given the user has accessibility tools enabled
    When the user navigates to the application homepage
    Then the title should display "Regression Tool"
    And the title should be readable by screen readers

  Scenario: Verify UI title in different browser environments
    Given the user opens the application in <browser>
    When the page is fully loaded
    Then the title should display "Regression Tool"

    Examples:
      | browser       |
      | Chrome        |
      | Firefox       |
      | Safari        |
      | Edge          |

  Scenario: Verify the UI title under slow network conditions
    Given the user accesses the application with a slow network
    When the page eventually loads
    Then the title should display "Regression Tool"

  Scenario: Verify the UI title after a page refresh
    Given the user is on the application homepage
    When the user refreshes the page
    Then the title should display "Regression Tool"

  Scenario: Verify the UI title when JavaScript is disabled
    Given the user accesses the application with JavaScript disabled
    When the page is fully loaded
    Then the title should display "Regression Tool"

  Scenario Outline: Verify UI title with different user roles
    Given the user logs in as a <role>
    When the homepage is displayed
    Then the title should display "Regression Tool"

    Examples:
      | role          |
      | Admin         |
      | Manager       |
      | Contributor   |
      | Viewer        |