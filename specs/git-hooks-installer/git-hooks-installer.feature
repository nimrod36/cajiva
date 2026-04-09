Feature: Automate the installation of Git hooks into a local repository

  As a developer
  I want to automate the installation of Git hooks into a repository
  So that I can ensure consistent workflows and reduce manual effort

  Background:
    Given the repository has a valid ".git" directory
    And the hooks library contains "pre-commit" and "pre-push" scripts

  Scenario: Install Git hooks in a repository with no existing hooks
    Given the ".git/hooks/" directory exists
    And the user has write permissions to the ".git/hooks/" directory
    When the user runs the installation script
    Then the "pre-commit" and "pre-push" hooks should be copied to the ".git/hooks/" directory
    And the copied hooks should be made executable

  Scenario: Overwrite existing hooks with confirmation
    Given the ".git/hooks/" directory contains an existing "pre-commit" hook
    And the user has write permissions to the ".git/hooks/" directory
    When the user runs the installation script
    And confirms to overwrite the existing hooks
    Then the "pre-commit" and "pre-push" hooks should be copied to the ".git/hooks/" directory
    And the copied hooks should be made executable

  Scenario: Abort installation when .git directory is missing
    Given the repository does not contain a ".git" directory
    When the user runs the installation script
    Then the script should abort with a clear error message
    And no changes should be made to the repository

  Scenario: Abort installation when hooks library is not accessible
    Given the hooks library does not contain "pre-commit" and "pre-push" scripts
    When the user runs the installation script
    Then the script should abort with a clear error message
    And no changes should be made to the repository

  Scenario: Abort installation when permissions are insufficient
    Given the user does not have write permissions to the ".git/hooks/" directory
    When the user runs the installation script
    Then the script should abort with a clear error message
    And no changes should be made to the repository