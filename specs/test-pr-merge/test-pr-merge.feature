Feature: Enforce branch protection through git hooks and CI
  As a developer
  I want git hooks to prevent commits and pushes when tests fail
  So that only tested and reliable code reaches the main branch and protect it

  Background:
    Given the cajiva repository has git hooks installed
    And all existing tests are passing

Scenario: Git hooks allow push when all tests pass
    Given all RSpec tests pass
    And all Cucumber scenarios pass
    When I attempt to push changes to the repository
    Then the pre-push hook allows the push
    And no test failures are reported

Scenario: Pre-commit hook blocks commit when RSpec tests fail
    Given an RSpec test has been modified to fail
    When I attempt to commit the changes
    Then the pre-commit hook blocks the commit
    And an error message indicates RSpec tests failed

Scenario: Pre-commit hook blocks commit when Cucumber scenarios fail
    Given a Cucumber step definition has been modified to fail
    When I attempt to commit the changes
    Then the pre-commit hook blocks the commit
    And an error message indicates Cucumber tests failed

Scenario: Verify all feature files have corresponding scenarios
    Given all feature files in the specs directory
    When I check for scenario coverage
    Then every feature file must have at least one scenario
    And every scenario must have step definitions

Scenario: Git hooks are installed and executable
    Given the repository root directory
    When I check the git hooks directory
    Then the pre-commit hook must exist
    And the pre-push hook must exist
    And both hooks must be executable
    And both hooks must contain test execution commands

Scenario: Hooks can be bypassed with SKIP_HOOKS flag
    Given an RSpec test has been modified to fail
    And the SKIP_HOOKS environment variable is set to "1"
    When I attempt to commit the changes
    Then the commit is allowed despite test failures
    And a warning message about skipping hooks is displayed

  Scenario: Pre-push hook runs full test suite
    Given all tests are currently passing
    When I trigger the pre-push hook directly
    Then both RSpec and Cucumber test suites are executed
    And test coverage analysis is performed
    And the hook exits with success status

  Scenario: Pre-push hook validates test coverage threshold
    Given all tests pass but coverage is below threshold
    When I attempt to push changes to the repository
    Then the pre-push hook checks coverage requirements
    And a warning message about insufficient coverage is displayed