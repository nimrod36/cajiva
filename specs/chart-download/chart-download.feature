Feature: Download chart as JPEG image
  Users can download the displayed chart as a JPEG file for offline use, reporting, or sharing.

  Background:
    Given a chart is displayed on the screen
    And the chart is fully rendered and visible
    And the user has permission to download the chart

  Rule: Users should be able to download a chart as a JPEG file
    Scenario: Download chart successfully
      When the user clicks the download button located at the top-right corner of the chart
      Then the system generates a JPEG file of the chart
      And the downloaded file matches the visual appearance of the on-screen chart
      And the file is named following the convention "chart_<timestamp>.jpeg"

    Scenario: Download fails due to rendering error
      Given the chart is not fully rendered
      When the user clicks the download button
      Then the system displays an error message indicating the chart cannot be downloaded at this time

    Scenario: Download button visibility
      Given the user is viewing a chart
      Then the download button is visible in the top-right corner of the chart container
      And the button remains accessible across different screen sizes


    Scenario: Large chart download
      Given a chart with complex and large dimensions is displayed on the screen
      When the user clicks the download button
      Then the system generates a JPEG file that accurately represents the chart
      And the download completes successfully within 3 seconds
