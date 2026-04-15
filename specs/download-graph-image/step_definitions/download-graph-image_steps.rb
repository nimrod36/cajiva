# frozen_string_literal: true

require 'rspec/expectations'

Before do
  @html_file = File.join(File.dirname(__FILE__), '../../../public/index.html')
  @html_content = File.read(@html_file)
end

# Background
Given('the graph is rendered and visible on the screen') do
  # Verify chart canvas element exists
  expect(@html_content).to include('id="regressionChart"')
  
  # Verify chart is initialized
  expect(@html_content).to match(/chart\s*=\s*new\s+Chart\(ctx/)
  
  # Verify chart container is visible
  expect(@html_content).to match(/<div[^>]+class=["'][^"']*chart-container[^"']*["'][^>]*>/)
end

# Rule: Download functionality must support multiple formats
# Scenario: Download the graph as a PNG image
When('the user clicks the download button') do
  # Verify download button exists
  expect(@html_content).to match(/<button[^>]+class=["'][^"']*download-btn[^"']*["'][^>]*onclick=["']openDownloadDialog\(\)["'][^>]*>/)
  expect(@html_content).to include('Download Graph')
  
  # Verify openDownloadDialog function exists
  expect(@html_content).to match(/function\s+openDownloadDialog\s*\(/)
  expect(@html_content).to match(/modal\.classList\.add\(['"]active['"]\)/)
end

When('selects {string} from the format options') do |format|
  @selected_format = format
  
  # Verify format selection exists in modal
  expect(@html_content).to match(/<input[^>]+type=["']radio["'][^>]+value=["']#{format.downcase}["']/)
  
  # Verify selectFormat function exists
  expect(@html_content).to match(/function\s+selectFormat\s*\(\s*format\s*\)/)
  expect(@html_content).to match(/selectedFormat\s*=\s*format/)
end

Then('the graph is downloaded as a PNG image') do
  # Verify download confirmation function exists
  expect(@html_content).to match(/function\s+confirmDownload\s*\(/)
  
  # Verify downloadChartAsPNG function exists
  expect(@html_content).to match(/function\s+downloadChartAsPNG\s*\(/)
  
  # Verify canvas.toDataURL for PNG conversion
  expect(@html_content).to match(/canvas\.toDataURL\(['"]image\/png['"]\)/)
  
  # Verify download link creation and triggering
  expect(@html_content).to match(/link\.download\s*=\s*['"]temperature-graph\.png['"]/)
  expect(@html_content).to match(/link\.href\s*=\s*imageURL/)
  expect(@html_content).to match(/link\.click\(\)/)
  
  # Verify success notification
  expect(@html_content).to match(/showNotification\([^)]*'Graph downloaded successfully as PNG'[^)]*'success'/)
end

Then('the downloaded image matches the displayed graph') do
  # Verify the download uses the actual chart canvas
  expect(@html_content).to match(/document\.getElementById\(['"]regressionChart['"]\)/)
  
  # Verify proper image data extraction
  expect(@html_content).to match(/canvas\.toDataURL/)
  
  # Verify validation that imageURL is not empty
  expect(@html_content).to match(/if\s*\(\s*!imageURL\s*\|\|\s*imageURL\s*===\s*['"]data:,['"]\s*\)/)
end

# Rule: Canceling the download action
# Scenario: Cancel the download action
When('cancels the action using the {string} button in the dialog') do |button_text|
  # Verify cancel button exists
  expect(@html_content).to match(/<button[^>]+class=["'][^"']*btn-cancel[^"']*["'][^>]*id=["']cancelDownloadBtn["'][^>]*onclick=["']closeDownloadDialog\(\)["']/)
  expect(@html_content).to include(button_text)
  
  # Verify closeDownloadDialog function exists
  expect(@html_content).to match(/function\s+closeDownloadDialog\s*\(/)
  expect(@html_content).to match(/modal\.classList\.remove\(['"]active['"]\)/)
end

Then('no graph image is downloaded') do
  # Verify closeDownloadDialog doesn't trigger download
  close_download_match = @html_content.match(/function\s+closeDownloadDialog\s*\([^)]*\)\s*\{[^}]*\}/m)
  expect(close_download_match).not_to be_nil
  expect(close_download_match[0]).not_to match(/downloadChartAsPNG/)
  expect(close_download_match[0]).not_to match(/toDataURL/)
  expect(close_download_match[0]).not_to match(/link\.click/)
end

Then('the user is returned to the graph view') do
  # Verify modal is closed properly
  expect(@html_content).to match(/modal\.classList\.remove\(['"]active['"]\)/)
  
  # Verify no navigation away from the page
  close_download_match = @html_content.match(/function\s+closeDownloadDialog\s*\([^)]*\)\s*\{[^}]*\}/m)
  expect(close_download_match[0]).not_to match(/window\.location/)
  expect(close_download_match[0]).not_to match(/redirect/)
end

# Rule: Handling unsupported scenarios
# Scenario: The dialog fails to load
Then('an error message is displayed') do
  # Verify error handling in openDownloadDialog exists
  open_dialog_match = @html_content.match(/function\s+openDownloadDialog\s*\([^)]*\)\s*\{.*?\n\s*try\s*\{.*?\}\s*catch\s*\(\s*error\s*\).*?\}/m)
  expect(open_dialog_match).not_to be_nil
  
  # Verify error notification call exists
  expect(@html_content).to match(/showNotification\([^)]*error[^)]*opening[^)]*download[^)]*dialog[^)]*,\s*['"]error['"]/i)
  
  # Verify error div exists in modal
  expect(@html_content).to match(/<div[^>]+id=["']downloadError["']/)
  
  # Verify error display in confirmDownload
  expect(@html_content).to match(/errorDiv\.textContent\s*=\s*['"].*error.*['"]/i)
  expect(@html_content).to match(/errorDiv\.style\.display\s*=\s*['"]block['"]/)
end

Then('the user is unable to proceed with the download') do
  # Verify error handling prevents download
  expect(@html_content).to match(/catch\s*\(\s*error\s*\)\s*\{/)
  
  # Verify error notification is shown for system failure
  expect(@html_content).to match(/showNotification\([^)]*system\s+failed\s+to\s+generate\s+the\s+image[^)]*,\s*['"]error['"]/i)
  
  # Verify errors are thrown to prevent download continuation
  expect(@html_content).to match(/throw\s+new\s+Error/)
end

# Scenario: The system fails to generate the image
When('selects a format') do
  # Verify format selection state
  expect(@html_content).to match(/let\s+selectedFormat\s*=\s*['"]png['"]/)
  
  # Verify format option is checked
  expect(@html_content).to match(/input[^>]+type=["']radio["'][^>]+value=["']png["'][^>]+checked/)
end
