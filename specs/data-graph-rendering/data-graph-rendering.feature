Feature: Data Graph Rendering
  As a user of the application
  I want the data graph to render correctly and reliably
  So that I can visualize data without errors or missing information

  Background:
    Given the application is launched
    And the user has access to the data visualization feature

  Scenario: The graph renders successfully with valid data
    Given valid data is available from the backend
    When the user navigates to the graph visualization page
    Then the graph should render correctly with all expected data points displayed

  Scenario: Graceful handling when no data is available
    Given no data is available from the backend
    When the user navigates to the graph visualization page
    Then the system should display a "No data available" message
    And the graph area should remain empty

  Scenario: Graceful handling of malformed data
    Given the backend returns malformed or corrupted data
    When the user navigates to the graph visualization page
    Then the system should display a user-friendly error message
    And the graph area should remain empty

  Scenario: Consistent graph rendering across all supported environments
    Given valid data is available from the backend
    When the user views the graph visualization page on a supported device or browser
    Then the graph should render correctly with all expected data points displayed

  Scenario: Rendering a large dataset
    Given a very large dataset is available from the backend
    When the user navigates to the graph visualization page
    Then the graph should render correctly without performance or memory issues

  Scenario: Live updates to the graph
    Given valid data is available from the backend
    And the graph is already rendered
    When new data is received by the system
    Then the graph should update dynamically to reflect the new data