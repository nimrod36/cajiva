Feature: Enforce full test coverage and passing tests before merging a pull request  
  As a development team  
  I want to ensure that a pull request cannot be merged unless all tests are implemented and passing  
  So that we maintain high code quality and prevent errors in the codebase  

  Background:  
    Given a repository with pull request checks enabled  
    And a pull request with associated test cases configured  

  Scenario: Merge PR when all test cases are implemented and passing  
    Given all test cases for the pull request are implemented  
    And all test cases are passing  
    When a developer attempts to merge the pull request  
    Then the pull request is successfully merged  

  Scenario: Prevent merge when not all test cases are implemented  
    Given some test cases for the pull request are not implemented  
    When a developer attempts to merge the pull request  
    Then the merge is blocked  
    And the reason displayed is "Missing coverage: not all test cases are implemented"  

  Scenario: Prevent merge when at least one test case is failing  
    Given all test cases for the pull request are implemented  
    And at least one test case is failing  
    When a developer attempts to merge the pull request  
    Then the merge is blocked  
    And the reason displayed is "Failing tests: not all tests are passing"  

  Scenario: Prevent merge when no tests are associated with the pull request  
    Given the pull request has no associated test cases  
    When a developer attempts to merge the pull request  
    Then the merge is blocked  
    And the reason displayed is "Missing coverage: no test cases associated with the pull request"  

  Scenario: Display reason for disabled merge when both coverage and tests are failing  
    Given some test cases for the pull request are not implemented  
    And at least one implemented test case is failing  
    When a developer attempts to merge the pull request  
    Then the merge is blocked  
    And the reason displayed is "Missing coverage: not all test cases are implemented; Failing tests: not all tests are passing"  

  Scenario: Merge PR when test cases are added and all tests pass after an initial failure  
    Given some test cases for the pull request were not implemented  
    And at least one test case was failing  
    When the missing test cases are implemented  
    And all test cases are passing  
    And a developer attempts to merge the pull request  
    Then the pull request is successfully merged  

  Scenario Outline: Prevent merge for various edge conditions  
    Given <condition>  
    When a developer attempts to merge the pull request  
    Then the merge is blocked  
    And the reason displayed is <reason>  

    Examples:  
      | condition                                      | reason                                      |  
      | some test cases are not implemented           | Missing coverage: not all test cases are implemented |  
      | all test cases are implemented but one fails  | Failing tests: not all tests are passing   |  
      | no test cases are associated with the pull request | Missing coverage: no test cases associated with the pull request |  
      | some cases not implemented and at least one fails | Missing coverage: not all test cases are implemented; Failing tests: not all tests are passing |