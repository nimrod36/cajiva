Feature: Git Hooks for Pre-Commit and Pre-Push

  As a developer  
  I want pre-commit and pre-push hooks to provide feedback on test coverage and test pass status without enforcing any restrictions  
  So that I can be informed about the code quality while maintaining flexibility in the development workflow  

  Background:  
    Given a git repository with pre-commit and pre-push hooks configured  
    And the hooks are set up to run tests and print coverage and test results  

  Scenario: Execute pre-commit hook with all tests passing  
    Given I have made changes to the codebase  
    And all tests pass successfully  
    When I stage the changes and trigger the pre-commit hook  
    Then the pre-commit hook should display the test results  
    And the pre-commit hook should display the test coverage  
    And the commit should proceed without enforcement  

  Scenario: Execute pre-commit hook with some tests failing  
    Given I have made changes to the codebase  
    And some tests fail during execution  
    When I stage the changes and trigger the pre-commit hook  
    Then the pre-commit hook should display the test results including the failures  
    And the pre-commit hook should display the test coverage  
    And the commit should proceed without enforcement  

  Scenario: Execute pre-push hook with all tests passing  
    Given I have committed my changes  
    And all tests pass successfully  
    When I push the changes to the remote repository  
    Then the pre-push hook should display the test results  
    And the pre-push hook should display the test coverage  
    And the push should proceed without enforcement  

  Scenario: Execute pre-push hook with some tests failing  
    Given I have committed my changes  
    And some tests fail during execution  
    When I push the changes to the remote repository  
    Then the pre-push hook should display the test results including the failures  
    And the pre-push hook should display the test coverage  
    And the push should proceed without enforcement  

  Scenario: Execute pre-commit hook with no tests defined  
    Given I have made changes to the codebase  
    And there are no tests defined in the project  
    When I stage the changes and trigger the pre-commit hook  
    Then the pre-commit hook should display a message indicating that no tests are defined  
    And the commit should proceed without enforcement  

  Scenario: Execute pre-push hook with no tests defined  
    Given I have committed my changes  
    And there are no tests defined in the project  
    When I push the changes to the remote repository  
    Then the pre-push hook should display a message indicating that no tests are defined  
    And the push should proceed without enforcement  

  Scenario: Execute pre-commit hook with incomplete test coverage  
    Given I have made changes to the codebase  
    And the test coverage is below the acceptable threshold  
    When I stage the changes and trigger the pre-commit hook  
    Then the pre-commit hook should display the test results  
    And the pre-commit hook should display the test coverage percentage  
    And the commit should proceed without enforcement  

  Scenario: Execute pre-push hook with incomplete test coverage  
    Given I have committed my changes  
    And the test coverage is below the acceptable threshold  
    When I push the changes to the remote repository  
    Then the pre-push hook should display the test results  
    And the pre-push hook should display the test coverage percentage  
    And the push should proceed without enforcement  

  Scenario: Pre-commit hook execution fails due to script error  
    Given I have made changes to the codebase  
    And there is an error in the pre-commit hook script  
    When I stage the changes and trigger the pre-commit hook  
    Then the pre-commit hook should display an error message indicating the script failure  
    And the commit should proceed despite the script error  

  Scenario: Pre-push hook execution fails due to script error  
    Given I have committed my changes  
    And there is an error in the pre-push hook script  
    When I push the changes to the remote repository  
    Then the pre-push hook should display an error message indicating the script failure  
    And the push should proceed despite the script error  

  Scenario Outline: Handle different edge cases for pre-commit hook  
    Given I have made changes to the codebase  
    And the project contains <test_condition>  
    When I stage the changes and trigger the pre-commit hook  
    Then the pre-commit hook should display the <expected_output>  
    And the commit should proceed without enforcement  

    Examples:  
      | test_condition          | expected_output                                   |  
      | no test framework       | "No test framework detected"                     |  
      | invalid test configuration | "Test configuration is invalid"               |  
      | long-running tests      | "Tests are taking longer than expected"          |  

  Scenario Outline: Handle different edge cases for pre-push hook  
    Given I have committed my changes  
    And the project contains <test_condition>  
    When I push the changes to the remote repository  
    Then the pre-push hook should display the <expected_output>  
    And the push should proceed without enforcement  

    Examples:  
      | test_condition          | expected_output                                   |  
      | no test framework       | "No test framework detected"                     |  
      | invalid test configuration | "Test configuration is invalid"               |  
      | long-running tests      | "Tests are taking longer than expected"          |