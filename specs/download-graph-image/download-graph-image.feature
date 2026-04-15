Feature: Download Graph as an Image
  To allow users to save visual data representations
  As a user
  I want to download a graph as an image in my preferred format

  Background:
    Given the graph is rendered and visible on the screen

  Rule: Download functionality must support multiple formats
    Scenario: Download the graph as a PNG image
      When the user clicks the download button
      And selects "PNG" from the format options
      Then the graph is downloaded as a PNG image
      And the downloaded image matches the displayed graph

    Scenario: Download the graph as a JPEG image
      When the user clicks the download button
      And selects "JPEG" from the format options
      Then the graph is downloaded as a JPEG image
      And the downloaded image matches the displayed graph

    Scenario: Download the graph as an SVG image
      When the user clicks the download button
      And selects "SVG" from the format options
      Then the graph is downloaded as an SVG file
      And the downloaded image matches the displayed graph

  Rule: Canceling the download action
    Scenario: Cancel the download action
      When the user clicks the download button
      And cancels the action using the "Cancel" button in the dialog
      Then no graph image is downloaded
      And the user is returned to the graph view

  Rule: Handling unsupported scenarios
    Scenario: The dialog fails to load
      When the user clicks the download button
      Then an error message is displayed
      And the user is unable to proceed with the download

    Scenario: The system fails to generate the image
      When the user clicks the download button
      And selects a format
      Then an error message is displayed
      And no graph image is downloaded