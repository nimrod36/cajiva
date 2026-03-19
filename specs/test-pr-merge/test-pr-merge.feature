Feature: Restrict pull request merge on spec failure  
  As a developer  
  I want to prevent pull requests from being merged if any spec fails  
  So that only valid and reliable code is merged into the main branch  

  Background:  
    Given a repository with branch protection rules configured  
    And a pull request exists with changes ready for review  

  Scenario: Successfully merge pull request when all specs pass  
    Given all specs are executed for the pull request  
    And all specs pass without errors  
    When the user attempts to merge the pull request  
    Then the pull request is successfully merged  
    And the branch is updated with the changes  

  Scenario: Prevent merging pull request when a spec fails  
    Given all specs are executed for the pull request  
    And at least one spec fails  
    When the user attempts to merge the pull request  
    Then the merge is blocked  
    And a message is displayed indicating that one or more specs failed  

  Scenario: Prevent merging pull request when spec execution is incomplete  
    Given spec execution is triggered for the pull request  
    And spec execution is still in progress  
    When the user attempts to merge the pull request  
    Then the merge is blocked  
    And a message is displayed indicating that spec execution is not yet complete  

  Scenario: Notify user when no specs are configured  
    Given the pull request does not have any specs configured  
    When the user attempts to merge the pull request  
    Then the merge is blocked  
    And a message is displayed indicating that no specs are configured for the repository  

  Scenario Outline: Prevent merging pull request with failing spec and display failure details  
    Given all specs are executed for the pull request  
    And the spec "<spec_name>" fails with error "<error_message>"  
    When the user attempts to merge the pull request  
    Then the merge is blocked  
    And a message is displayed indicating the failure in "<spec_name>" with the error "<error_message>"  

    Examples:  
      | spec_name       | error_message                 |  
      | Authentication  | Invalid token response       |  
      | DataValidation  | Missing required field: email|  

  Scenario: Merge pull request when branch protection rules are disabled  
    Given branch protection rules are disabled for the repository  
    And all specs are executed for the pull request  
    And at least one spec fails  
    When the user attempts to merge the pull request  
    Then the pull request is successfully merged  
    And the branch is updated with the changes  

  Scenario: Prevent merging pull request due to network issues during spec execution  
    Given spec execution is triggered for the pull request  
    And the spec execution fails due to a network issue  
    When the user attempts to merge the pull request  
    Then the merge is blocked  
    And a message is displayed indicating that spec execution could not be completed due to network issues