Feature: Toggle chart views
  Users can switch between scatter plot and bar chart views for visualizing a dataset, while maintaining the visibility and accuracy of the regression line.

  Background:
    Given the charting system is initialized
    And a dataset is loaded into the visualization

  Rule: Chart toggling
    The user can toggle between scatter plot and bar chart views without losing dataset or regression line context.

    Scenario: Toggle from scatter plot to bar chart
      Given a scatter plot chart is displayed with a regression line
      When the user toggles to a bar chart
      Then the chart switches to the bar chart view
      And the regression line is displayed correctly on the bar chart

    Scenario: Toggle from bar chart to scatter plot
      Given a bar chart is displayed with a regression line
      When the user toggles to a scatter plot
      Then the chart switches to the scatter plot view
      And the regression line is displayed correctly on the scatter plot

    Scenario: Preserve dataset context across toggles
      Given a user has adjusted the view (e.g., zoomed in) on the chart
      When the user toggles between scatter plot and bar chart
      Then the adjusted view is preserved in the new chart type

  Rule: Error handling for unsupported data
    The system must handle datasets that cannot be visualized in one of the chart types.

    Scenario: Unsupported data for scatter plot
      Given a dataset cannot be visualized as a scatter plot
      When the user toggles to scatter plot view
      Then the system displays an error message
      And the chart remains in the previous view

    Scenario: Unsupported data for bar chart
      Given a dataset cannot be visualized as a bar chart
      When the user toggles to bar chart view
      Then the system displays an error message
      And the chart remains in the previous view

  Rule: Responsiveness
    The toggle control and chart views must function correctly across devices and screen sizes.

    Scenario: Toggle charts on a mobile device
      Given a user is viewing the chart on a mobile device
      When the user toggles between scatter plot and bar chart
      Then the toggle control and chart display correctly without breaking layout