Feature: Git Hook Installation
  Developers can run an installation script to set up Git hooks in the repository, ensuring consistent code quality and automated checks during pre-commit and pre-push operations.

  Background:
    Given the repository includes the necessary hook scripts in a "hooks" folder
    And the user has cloned the repository locally
    And the user has Git installed and functional on their system

  Rule: Installation Script Behavior
    - The script must install hooks without overwriting existing configurations unless explicitly confirmed.
    - The script must fail gracefully if prerequisites are unmet.

  Scenario: Installing Git hooks successfully
    Given the user runs the installation script
    Then the script installs the "pre-commit" and "pre-push" hooks in the ".git/hooks/" directory
    And the hooks are triggered automatically during their respective Git operations

  Scenario: Detecting and handling pre-existing hooks
    Given the ".git/hooks/" directory already contains a "pre-commit" hook
    When the user runs the installation script
    Then the script asks the user for explicit confirmation to overwrite the existing hook
    And the hook is replaced only if the user confirms

  Scenario: Failing gracefully on missing prerequisites
    Given the user runs the installation script without necessary dependencies installed
    Then the script exits gracefully with an error message
    And it provides instructions to resolve the issue

  Scenario: Ensuring hooks remain functional after manual modifications
    Given the user runs the installation script
    And the hooks are successfully installed
    When the user manually modifies a hook after installation
    Then the script detects the modification during a re-run
    And it warns the user about the changes without overwriting them