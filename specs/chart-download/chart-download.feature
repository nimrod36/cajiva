Feature: Download chart as JPEG
  As a user
  I want to download a chart as a JPEG file
  So that I can save or share the chart's insights visually

  Background:
    Given a fully rendered chart is displayed on the screen

  Scenario: Download chart successfully
    When the user clicks the download button at the top-right corner of the chart
    Then the chart is downloaded as a high-quality JPEG file

  Scenario: Handle rendering error gracefully
    Given the chart has failed to render
    When the user clicks the download button
    Then an error message is displayed indicating the chart cannot be downloaded

  Scenario: Preserve style consistency in download
    Given the chart contains specific styles, colors, labels, and legends
    When the user clicks the download button
    Then the downloaded JPEG file preserves the chart's styles, colors, labels, and legends


