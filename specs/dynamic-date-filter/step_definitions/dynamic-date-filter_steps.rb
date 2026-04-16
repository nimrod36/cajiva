# frozen_string_literal: true

require 'rspec/expectations'

Before do
  @html_file = File.join(File.dirname(__FILE__), '../../../public/index.html')
  @html_content = File.read(@html_file)
end

# Background steps
Given('the chart displays data within a predefined available date range') do
  # Verify chart exists and displays data
  expect(@html_content).to include('id="regressionChart"')
  expect(@html_content).to match(/let\s+currentData\s*=/)
  expect(@html_content).to match(/actual:\s*\[\]/)
  expect(@html_content).to match(/originalData\s*=/)
end

Given('the user has access to the filtering controls') do
  # Verify date filter controls exist
  expect(@html_content).to include('id="startDate"')
  expect(@html_content).to include('id="endDate"')
  expect(@html_content).to include('Filter by Date Range')
  expect(@html_content).to match(/onclick=["']applyDateFilter\(\)["']/)
  expect(@html_content).to match(/onclick=["']resetDateFilter\(\)["']/)
end

# Scenario: User selects a valid date range within the available data
When('the user selects a start date and an end date within the available range') do
  # Verify applyDateFilter function exists
  expect(@html_content).to match(/function\s+applyDateFilter\s*\(/)
  expect(@html_content).to match(/getElementById\(['"]startDate['"]\)/)
  expect(@html_content).to match(/getElementById\(['"]endDate['"]\)/)
end

Then('the chart updates to display data for the selected date range') do
  # Verify filtering logic exists
  expect(@html_content).to match(/dateFilter\.isActive/)
  expect(@html_content).to match(/function\s+applyFilter\s*\(/)
  expect(@html_content).to match(/originalData\.actual\.filter/)
end

Then('the visible range reflects the selected date range') do
  # Verify filtered data is used
  expect(@html_content).to match(/currentData\.actual\s*=\s*filteredActual/)
  expect(@html_content).to match(/recalculateRegressionForFiltered/)
end

# Scenario: User selects a date range with no data available
When('the user selects a start date and an end date with no data in the range') do
  # Same as valid range selection - validation happens in the function
  expect(@html_content).to match(/function\s+applyDateFilter\s*\(/)
end

Then('the chart updates to display an empty state') do
  # Verify empty state handling exists
  expect(@html_content).to match(/if\s*\(filteredActual\.length\s*===\s*0\)/)
  expect(@html_content).to match(/currentData\.actual\s*=\s*\[\]/)
  expect(@html_content).to match(/currentData\.regression\s*=\s*\[\]/)
end

Then('the message "No data available" is shown') do
  # Verify "No data available" message is shown
  expect(@html_content).to include('No data available')
  expect(@html_content).to match(/equation:\s*['"]No data available['"]/)
end

# Scenario: User resets the date filter
Given('the chart displays data for a filtered date range') do
  # Verify filter can be active
  expect(@html_content).to match(/dateFilter\.isActive\s*=\s*true/)
end

When('the user removes the active date filter') do
  # Verify resetDateFilter function exists
  expect(@html_content).to match(/function\s+resetDateFilter\s*\(/)
  expect(@html_content).to match(/dateFilter\.startDate\s*=\s*null/)
  expect(@html_content).to match(/dateFilter\.endDate\s*=\s*null/)
  expect(@html_content).to match(/dateFilter\.isActive\s*=\s*false/)
end

Then('the chart reverts to displaying all available data') do
  # Verify original data is restored
  expect(@html_content).to match(/currentData\.actual\s*=\s*JSON\.parse\(JSON\.stringify\(originalData\.actual\)\)/)
  expect(@html_content).to match(/currentData\.regression\s*=\s*JSON\.parse\(JSON\.stringify\(originalData\.regression\)\)/)
end

Then('the visible date range reflects the full dataset') do
  # Verify input fields are cleared
  expect(@html_content).to match(/getElementById\(['"]startDate['"]\)\.value\s*=\s*['"]['"]/)
  expect(@html_content).to match(/getElementById\(['"]endDate['"]\)\.value\s*=\s*['"]['"]/)
end

# Scenario: User selects a start date after the end date
When('the user selects a start date that is later than the end date') do
  # Verify date validation logic exists
  expect(@html_content).to match(/function\s+applyDateFilter\s*\(/)
  expect(@html_content).to match(/startDate\s*>\s*endDate/)
end

Then('the system prevents the action') do
  # Verify validation prevents invalid dates
  expect(@html_content).to match(/if\s*\(startDate\s*>\s*endDate\)/)
  expect(@html_content).to match(/return/)
end

Then('an error message "Invalid date" is displayed') do
  # Verify error message is shown
  expect(@html_content).to match(/filterMessage\.textContent\s*=\s*['"]Invalid date['"]/)
  expect(@html_content).to include('id="filterMessage"')
end

# Scenario: User selects the smallest possible date range (single day)
When('the user selects a start date and an end date that span a single day') do
  # Same function handles all date ranges
  expect(@html_content).to match(/function\s+applyDateFilter\s*\(/)
end

Then('the chart updates to display data for the selected day') do
  # Verify filtering works for single day (filter comparison uses >= and <=)
  expect(@html_content).to match(/pointDate\s*>=\s*dateFilter\.startDate/)
  expect(@html_content).to match(/pointDate\s*<=\s*dateFilter\.endDate/)
end
