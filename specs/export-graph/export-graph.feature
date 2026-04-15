Feature: Export graph as an image
  Users can export a graph displayed on the screen as an image in selectable formats (JPEG or PNG), enabling seamless sharing, reporting, or offline usage.

  Background:
    Given a graph is rendered and visible to the user

  Rule: Format selection for image export
    The user must choose between JPEG and PNG formats when exporting the graph.

    Scenario: Exporting a graph as a JPEG
      When the user clicks the download button
      And selects JPEG from the format selection dialog
      And confirms the action
      Then the graph is downloaded as a JPEG image
      And the downloaded image matches the current state of the graph

    Scenario: Exporting a graph as a PNG
      When the user clicks the download button
      And selects PNG from the format selection dialog
      And confirms the action
      Then the graph is downloaded as a PNG image
      And the downloaded image matches the current state of the graph

  Rule: Canceling the export action
    Scenario: Canceling the export
      When the user clicks the download button
      And opens the format selection dialog
      But clicks "Cancel" or closes the dialog
      Then no image is downloaded

  Rule: Error handling during export
    Scenario: Failure to generate the image
      Given the system encounters an error during image generation
      When the user attempts to export the graph
      Then the system displays an error message
      And no image is downloaded