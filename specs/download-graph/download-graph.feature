Feature: Download Graph Visualization
  As a user
  I want to download a graph visualization in various formats
  So that I can use the graph offline for reports, presentations, or archival

  Background:
    Given a rendered graph is visible to the user

  Rule: Export Options
    - Users must be able to download the graph in JPEG, PNG, or PDF formats.
    - The graph must accurately represent the current rendered state.

  Scenario: Successful download of a graph visualization
    Given the graph download button is visible in the upper-right corner of the graph
    When the user clicks the download button
    Then the system should display a dialog with file format options: "JPEG", "PNG", and "PDF"
    When the user selects a format "JPEG"
    And confirms the download action
    Then the system should generate a file in "JPEG" format
    And the file should accurately represent the current graph state

  Scenario: Cancelling the download action
    Given the graph download button is visible in the upper-right corner of the graph
    When the user clicks the download button
    Then the system should display a dialog with file format options: "JPEG", "PNG", and "PDF"
    When the user cancels the action
    Then the dialog should close
    And the graph view should remain unchanged

  Scenario: File download failure
    Given the graph download button is visible in the upper-right corner of the graph
    When the user clicks the download button
    And selects a format "PDF"
    And confirms the download action
    And the download fails due to insufficient memory
    Then the system should notify the user with an error message
    And the graph view should remain unchanged