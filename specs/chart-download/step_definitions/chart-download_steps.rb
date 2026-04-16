# frozen_string_literal: true

require 'rspec/expectations'

Before do
  @html_file = File.join(File.dirname(__FILE__), '../../../public/index.html')
  @html_content = File.read(@html_file)
end

# Background step
Given('a fully rendered chart is displayed on the screen') do
  # Verify chart canvas element exists
  expect(@html_content).to include('id="regressionChart"')
  
  # Verify chart is created using Chart.js
  expect(@html_content).to match(/chart\s*=\s*new\s+Chart\s*\(/)
  
  # Verify chart container exists
  expect(@html_content).to match(/<div[^>]*class=["'][^"']*chart-container[^"']*["'][^>]*id=["']chartContainer["']/)
  
  # Verify createChart function exists
  expect(@html_content).to match(/function\s+createChart\s*\(/)
end

# Scenario: Download chart successfully
When('the user clicks the download button at the top-right corner of the chart') do
  # Verify download button exists at top-right
  expect(@html_content).to match(/<button[^>]*class=["'][^"']*download-btn[^"']*["']/)
  expect(@html_content).to match(/id=["']downloadBtn["']/)
  
  # Verify button is positioned correctly (top-right)
  download_btn_style = @html_content.match(/\.download-btn\s*\{[^}]*\}/m)
  expect(download_btn_style).not_to be_nil
  expect(download_btn_style[0]).to match(/position:\s*absolute/)
  expect(download_btn_style[0]).to match(/top:\s*\d+px/)
  expect(download_btn_style[0]).to match(/right:\s*\d+px/)
  
  # Verify onclick handler
  expect(@html_content).to match(/onclick=["']downloadChartAsJPEG\(\)["']/)
  
  # Verify downloadChartAsJPEG function exists
  expect(@html_content).to match(/function\s+downloadChartAsJPEG\s*\(/)
end

Then('the chart is downloaded as a high-quality JPEG file') do
  # Verify function uses toBase64Image with JPEG format
  expect(@html_content).to match(/chart\.toBase64Image\s*\(\s*['"]image\/jpeg['"]/)
  
  # Verify high quality setting (0.9 or higher)
  jpeg_quality_match = @html_content.match(/toBase64Image\s*\(\s*['"]image\/jpeg['"]\s*,\s*(0\.\d+|1\.0)\s*\)/)
  expect(jpeg_quality_match).not_to be_nil
  quality = jpeg_quality_match[1].to_f
  expect(quality).to be >= 0.9
  
  # Verify download link creation
  expect(@html_content).to match(/downloadLink\s*=\s*document\.createElement\s*\(\s*['"]a['"]\s*\)/)
  expect(@html_content).to match(/downloadLink\.href\s*=\s*imageData/)
  expect(@html_content).to match(/downloadLink\.download\s*=/)
  
  # Verify filename includes JPEG extension
  expect(@html_content).to match(/\.download\s*=\s*`[^`]*\.jpeg`/)
  
  # Verify download is triggered
  expect(@html_content).to match(/downloadLink\.click\s*\(\s*\)/)
  
  # Verify success notification is shown
  expect(@html_content).to match(/showNotification\s*\([^)]*['"]Chart downloaded successfully[^)]*['"]success['"]/)
end

# Scenario: Handle rendering error gracefully
Given('the chart has failed to render') do
  # Verify downloadChartAsJPEG checks if chart exists
  expect(@html_content).to match(/if\s*\(\s*!chart\s*\)/)
  
  # Verify canvas validation exists
  expect(@html_content).to match(/canvas\s*=\s*document\.getElementById\s*\(\s*['"]regressionChart['"]\s*\)/)
  expect(@html_content).to match(/if\s*\([^)]*canvas[^)]*\)/)
end

When('the user clicks the download button') do
  # Same as successful scenario - verify button exists and handler
  expect(@html_content).to match(/onclick=["']downloadChartAsJPEG\(\)["']/)
  expect(@html_content).to match(/function\s+downloadChartAsJPEG\s*\(/)
end

Then('an error message is displayed indicating the chart cannot be downloaded') do
  # Verify error notification for chart not rendered
  expect(@html_content).to match(/showNotification\s*\([^)]*['"]Chart has not been rendered[^)]*['"]error['"]/)
  
  # Verify error notification for canvas validation failure
  expect(@html_content).to match(/showNotification\s*\([^)]*['"]Chart cannot be downloaded[^)]*['"]error['"]/)
  
  # Verify try-catch block exists for error handling
  expect(@html_content).to match(/function\s+downloadChartAsJPEG\s*\([^)]*\)\s*\{\s*try/m)
  expect(@html_content).to match(/\}\s*catch\s*\([^)]*error[^)]*\)/m)
  
  # Verify error handler shows appropriate message
  expect(@html_content).to match(/catch.*showNotification.*Unable to download/m)
end

# Scenario: Preserve style consistency in download
Given('the chart contains specific styles, colors, labels, and legends') do
  # Verify chart has styled datasets with colors
  expect(@html_content).to match(/backgroundColor:\s*['"]rgba\([^)]+\)['"]/)
  expect(@html_content).to match(/borderColor:\s*['"]rgba\([^)]+\)['"]/)
  
  # Verify chart has labels
  expect(@html_content).to match(/label:\s*['"][^'"]+['"]/)
  
  # Verify chart has title
  expect(@html_content).to match(/title:\s*\{[^}]*display:\s*true[^}]*text:/m)
  
  # Verify chart has axis labels
  expect(@html_content).to match(/x:\s*\{[^}]*title:\s*\{[^}]*text:/m)
  expect(@html_content).to match(/y:\s*\{[^}]*title:\s*\{[^}]*text:/m)
  
  # Verify legend is displayed
  expect(@html_content).to match(/legend:\s*\{[^}]*display:\s*true/m)
end

Then('the downloaded JPEG file preserves the chart\'s styles, colors, labels, and legends') do
  # Verify toBase64Image captures the entire rendered canvas
  # which automatically includes all visual elements
  expect(@html_content).to match(/chart\.toBase64Image\s*\(\s*['"]image\/jpeg['"]/)
  
  # toBase64Image from Chart.js captures the complete rendered canvas
  # including all styles, colors, labels, and legends without modification
  # This is the standard behavior and preserves everything visually
  
  # Verify the image data is used directly for download
  expect(@html_content).to match(/const\s+imageData\s*=\s*chart\.toBase64Image/)
  expect(@html_content).to match(/downloadLink\.href\s*=\s*imageData/)
  
  # Ensure no modifications between capture and download
  # The imageData variable should be assigned directly to href
  download_section = @html_content.match(/const\s+imageData\s*=\s*chart\.toBase64Image.*?downloadLink\.href\s*=\s*imageData/m)
  expect(download_section).not_to be_nil
end
