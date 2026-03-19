Feature: Prompt improvement to use only kickoff

  As a system administrator
  I want the system to use only the kickoff workflow for generating BDD test plans
  So that redundant workflows are eliminated and the process is streamlined

  Background:
    Given the system is configured with both BDD plan and kickoff workflows
    And an action is triggered to generate a test plan

  Scenario: Happy path - Use only kickoff workflow for test plan generation
    Given both the BDD plan and kickoff workflows are available
    When an action to generate a test plan is triggered
    Then only the kickoff workflow should be executed
    And the BDD plan workflow should not be triggered

  Scenario: Edge case - Both workflows are disabled
    Given both the BDD plan and kickoff workflows are disabled
    When an action to generate a test plan is triggered
    Then no workflow should be executed
    And an error message "No workflows available for test plan generation" should be logged

  Scenario: Edge case - Only the kickoff workflow is enabled
    Given the kickoff workflow is enabled
    And the BDD plan workflow is disabled
    When an action to generate a test plan is triggered
    Then the kickoff workflow should be executed
    And the test plan should be generated successfully

  Scenario: Error handling - Invalid configuration for workflows
    Given the system configuration for workflows is invalid
    When an action to generate a test plan is triggered
    Then an error message "Invalid workflow configuration" should be logged
    And no workflow should be executed

  Scenario Outline: Data-driven validation for workflow states
    Given the kickoff workflow is <kickoff_state>
    And the BDD plan workflow is <bdd_plan_state>
    When an action to generate a test plan is triggered
    Then the system should execute workflows as per the configuration
    And <expected_outcome>

    Examples:
      | kickoff_state | bdd_plan_state | expected_outcome                                  |
      | enabled       | disabled       | kickoff workflow executed successfully          |
      | disabled      | enabled        | BDD plan workflow not executed, no action taken |
      | disabled      | disabled       | No workflows executed, error logged             |
      | enabled       | enabled        | kickoff workflow executed successfully          |