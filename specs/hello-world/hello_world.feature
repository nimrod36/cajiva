Feature: Hello World

  Scenario: Display Hello World message
    Given I have a setup ready
    When I run the hello world script
    Then I should see "Hello, World!" displayed