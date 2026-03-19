Feature: Use only kickoff workflow for feature initialization

  As a developer
  I want issues to trigger only the kickoff workflow
  So that the old generate-test-plan workflow is completely removed and we have a single clear automation path

  Background:
    Given the kickoff workflow exists at ".github/workflows/kickoff-feature-automation.yml"

  Scenario: Issue creation triggers only kickoff workflow
    Given a new GitHub issue is created
    When the issue event is processed
    Then the kickoff-feature-automation workflow should be triggered
    And the generate-test-plan workflow should not exist

  Scenario: Kickoff workflow is the only automation for issues
    Given I check the workflows directory
    Then only "kickoff-feature-automation.yml" should be present for issue automation
    And "generate-test-plan.yml" should not exist

  Scenario: Kickoff handles all feature initialization steps
    Given a new feature issue is opened with title and description
    When the kickoff workflow executes
    Then it should read the kickoff-feature prompt
    And it should read the create-test-plan prompt
    And it should generate a comprehensive BDD test plan
    And it should comment the plan on the issue

  Scenario: Workflow triggers on correct issue events
    Given the kickoff workflow configuration is loaded
    Then it should trigger on "opened" issue events
    And it should trigger on "reopened" issue events
    And it should not trigger on "closed" issue events

  Scenario: Old workflow is completely removed
    Given I search for workflow files that handle issue events
    Then I should find only "kickoff-feature-automation.yml"
    And I should not find "generate-test-plan.yml" anywhere
    And no other workflow should duplicate test plan generation

  # Three Amigos Coverage:
  # Product (Developer): Happy path - single workflow executes correctly
  # Developer (QA): Boundary - old workflow completely removed, correct event triggers
  # Tester (Edge): Workflow doesn't exist = no accidental execution