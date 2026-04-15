# frozen_string_literal: true

require 'rspec/expectations'

Before do
  @html_file = File.join(File.dirname(__FILE__), '../../../public/index.html')
  @html_content = File.read(@html_file)
end

Given('a graph is rendered and visible to the user') do
  # Verify chart canvas element exists
  expect(@html_content).to match(/<canvas\s+id=["']regressionChart["']/)
  
  # Verify Chart.js is loaded
  expect(@html_content).to include('chart.js')
  
  # Verify chart initialization code exists
  expect(@html_content).to match(/chart\s*=\s*new\s+Chart\s*\(/)
  expect(@html_content).to match(/function\s+createChart\s*\(/)
end

When('the user clicks the download button') do
  # Verify download button exists
  expect(@html_content).to match(/<button[^>]*class=["'][^"']*btn-download[^"']*["'][^>]*onclick=["']openExportDialog\(\)["']/)
  expect(@html_content).to match(/<button[^>]*id=["']downloadButton["']/)
  
  # Verify button has download icon/text
  expect(@html_content).to match(/Download\s+Graph/)
end

When('selects JPEG from the format selection dialog') do
  # Verify JPEG radio button exists
  expect(@html_content).to match(/<input\s+type=["']radio["'][^>]*id=["']formatJPEG["'][^>]*value=["']jpeg["']/)
  expect(@html_content).to match(/<input[^>]*name=["']exportFormat["'][^>]*value=["']jpeg["']/)
  
  # Verify JPEG label exists
  expect(@html_content).to match(/<label\s+for=["']formatJPEG["']>JPEG<\/label>/)
end

When('selects PNG from the format selection dialog') do
  # Verify PNG radio button exists
  expect(@html_content).to match(/<input\s+type=["']radio["'][^>]*id=["']formatPNG["'][^>]*value=["']png["']/)
  expect(@html_content).to match(/<input[^>]*name=["']exportFormat["'][^>]*value=["']png["']/)
  
  # Verify PNG label exists
  expect(@html_content).to match(/<label\s+for=["']formatPNG["']>PNG<\/label>/)
end

When('confirms the action') do
  # Verify export/confirm button exists in format selector
  expect(@html_content).to match(/<button[^>]*onclick=["']confirmExport\(\)["']>Export<\/button>/)
  
  # Verify confirmExport function exists
  expect(@html_content).to match(/function\s+confirmExport\s*\(/)
end

Then('the graph is downloaded as a JPEG image') do
  # Verify confirmExport function handles JPEG format
  expect(@html_content).to match(/canvas\.toDataURL\(['"]image\/jpeg['"]/)
  expect(@html_content).to match(/filename\s*=\s*['"]cajiva-graph\.jpeg['"]/)
  
  # Verify download link creation
  expect(@html_content).to match(/downloadLink\s*=\s*document\.createElement\(['"]a['"]\)/)
  expect(@html_content).to match(/downloadLink\.href\s*=\s*imageDataUrl/)
  expect(@html_content).to match(/downloadLink\.download\s*=\s*filename/)
  expect(@html_content).to match(/downloadLink\.click\(\)/)
end

Then('the graph is downloaded as a PNG image') do
  # Verify confirmExport function handles PNG format
  expect(@html_content).to match(/canvas\.toDataURL\(['"]image\/png['"]\)/)
  expect(@html_content).to match(/filename\s*=\s*['"]cajiva-graph\.png['"]/)
  
  # Verify download link creation
  expect(@html_content).to match(/downloadLink\s*=\s*document\.createElement\(['"]a['"]\)/)
  expect(@html_content).to match(/downloadLink\.href\s*=\s*imageDataUrl/)
  expect(@html_content).to match(/downloadLink\.download\s*=\s*filename/)
  expect(@html_content).to match(/downloadLink\.click\(\)/)
end

Then('the downloaded image matches the current state of the graph') do
  # Verify canvas element is used directly for export
  expect(@html_content).to match(/const\s+canvas\s*=\s*document\.getElementById\(['"]regressionChart['"]\)/)
  
  # Verify toDataURL is called on the canvas (captures current state)
  expect(@html_content).to match(/canvas\.toDataURL\(/)
  
  # Verify no separate rendering or state is used
  expect(@html_content).to match(/imageDataUrl\s*=\s*canvas\.toDataURL/)
end

When('opens the format selection dialog') do
  # Verify format selector element exists
  expect(@html_content).to match(/<div\s+id=["']formatSelector["'][^>]*class=["'][^"']*format-selector[^"']*["']/)
  
  # Verify openExportDialog function shows the format selector
  expect(@html_content).to match(/function\s+openExportDialog\s*\(/)
  expect(@html_content).to match(/formatSelector\.style\.display\s*=\s*['"]block['"]/)
end

When('clicks "Cancel" or closes the dialog') do
  # Verify cancel button exists
  expect(@html_content).to match(/<button[^>]*class=["'][^"']*btn-cancel[^"']*["'][^>]*onclick=["']cancelExport\(\)["']>Cancel<\/button>/)
  
  # Verify cancelExport function exists
  expect(@html_content).to match(/function\s+cancelExport\s*\(/)
end

Then('no image is downloaded') do
  # Verify cancelExport function hides the format selector without downloading
  expect(@html_content).to match(/function\s+cancelExport\s*\(\)\s*{/)
  expect(@html_content).to match(/formatSelector\.style\.display\s*=\s*['"]none['"]/)
  
  # Verify cancel function does not call toDataURL or create download link
  cancel_function = @html_content.match(/function\s+cancelExport\s*\(\)\s*{[^}]*}/m)[0]
  expect(cancel_function).not_to match(/toDataURL/)
  expect(cancel_function).not_to match(/createElement\(['"]a['"]\)/)
end

Given('the system encounters an error during image generation') do
  # Verify confirmExport has try-catch error handling
  expect(@html_content).to match(/try\s*{[\s\S]*?canvas\.toDataURL[\s\S]*?}\s*catch/)
  
  # Verify error handling code exists in confirmExport
  expect(@html_content).to match(/function\s+confirmExport[\s\S]*?catch\s*\(/)
end

When('the user attempts to export the graph') do
  # Verify confirmExport function can be called
  expect(@html_content).to match(/function\s+confirmExport\s*\(/)
  
  # Verify format selection and export logic exists
  expect(@html_content).to match(/document\.querySelector\(['"]input\[name=/)
end

Then('the system displays an error message') do
  # Verify error notification is shown
  expect(@html_content).to match(/showNotification\([^,]*,\s*['"]error['"]\)/)
  
  # Verify specific error message for export failure exists in confirmExport
  expect(@html_content).to match(/showNotification\(['"]Failed to export graph/i)
  
  # Verify error is logged
  expect(@html_content).to match(/console\.error\(['"]Error exporting graph/)
end
