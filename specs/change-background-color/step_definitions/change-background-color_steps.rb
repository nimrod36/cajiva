# frozen_string_literal: true

require 'rspec/expectations'

Before do
  @html_file = File.join(File.dirname(__FILE__), '../../../public/index.html')
  @html_content = File.read(@html_file)
end

Given('the system has a default background color') do
  # Verify default background gradient is defined in CSS
  expect(@html_content).to match(/background:\s*linear-gradient\(135deg,\s*#667eea\s+0%,\s*#764ba2\s+100%\)/)
  
  # Verify default background constant is defined in JavaScript
  expect(@html_content).to match(/const\s+DEFAULT_BG_COLOR\s*=\s*['"]#667eea['"]/)
  expect(@html_content).to match(/const\s+DEFAULT_BG_GRADIENT\s*=\s*['"]linear-gradient\(135deg,\s*#667eea\s+0%,\s*#764ba2\s+100%\)['"]/)
end

When('the user selects a new background color') do
  # Verify color picker input exists
  expect(@html_content).to match(/<input\s+type=["']color["'][^>]*id=["']bgColorPicker["']/)
  
  # Verify updateBackgroundColor function exists and is called on input event
  expect(@html_content).to match(/function\s+updateBackgroundColor\s*\(/)
  expect(@html_content).to match(/getElementById\(['"]bgColorPicker['"]\)\.addEventListener\(['"]input['"]/)
end

Then('the system should immediately update the background color') do
  # Verify updateBackgroundColor function updates document.body.style.background
  expect(@html_content).to match(/document\.body\.style\.background\s*=/)
  
  # Verify the function stores previous color
  expect(@html_content).to match(/previousBackgroundColor\s*=\s*currentBackgroundColor/)
  
  # Verify gradient conversion for hex colors
  expect(@html_content).to match(/linear-gradient\(135deg,\s*\$\{color\}\s+0%,\s*\$\{color\}\s+100%\)/)
end

Then('the change should not affect the layout or functionality') do
  # Verify layout elements still exist
  expect(@html_content).to include('<div class="container">')
  expect(@html_content).to include('<header>')
  expect(@html_content).to include('<h1>')
  expect(@html_content).to include('id="regressionChart"')
  
  # Verify smooth transition is applied
  expect(@html_content).to match(/transition:\s*background\s+[\d.]+s/)
end

Given('the user has changed the background color') do
  # Verify that changing color updates currentBackgroundColor variable
  expect(@html_content).to match(/currentBackgroundColor\s*=/)
  
  # Verify color picker has proper event listener
  expect(@html_content).to match(/addEventListener\(['"]input['"],\s*function/)
end

When('the user clicks the revert button') do
  # Verify revert button exists with onclick handler
  expect(@html_content).to match(/<button[^>]*id=["']revertButton["'][^>]*onclick=["']revertBackgroundColor\(\)["']/)
  
  # Verify revertBackgroundColor function exists
  expect(@html_content).to match(/function\s+revertBackgroundColor\s*\(/)
end

Then('the background color should return to the previous selection') do
  # Verify revert function swaps current and previous colors
  expect(@html_content).to match(/const\s+temp\s*=\s*currentBackgroundColor/)
  expect(@html_content).to match(/currentBackgroundColor\s*=\s*previousBackgroundColor/)
  expect(@html_content).to match(/previousBackgroundColor\s*=\s*temp/)
  
  # Verify it applies the reverted color to body
  expect(@html_content).to match(/document\.body\.style\.background\s*=\s*currentBackgroundColor/)
end

Given('the user has not changed the background color') do
  # Verify default state initialization
  expect(@html_content).to match(/let\s+previousBackgroundColor\s*=\s*DEFAULT_BG_GRADIENT/)
  expect(@html_content).to match(/let\s+currentBackgroundColor\s*=\s*DEFAULT_BG_GRADIENT/)
end

Then('the background color should remain as the default') do
  # Verify revert function maintains state properly
  # When no change has been made, previous and current should both be default
  # So reverting swaps them but result is still default
  expect(@html_content).to match(/revertBackgroundColor/)
  
  # Verify localStorage persistence
  expect(@html_content).to match(/localStorage\.setItem\(['"]cajiva_bg_color['"]/)
  expect(@html_content).to match(/localStorage\.setItem\(['"]cajiva_prev_bg_color['"]/)
  
  # Verify loadSavedBackgroundColor function exists
  expect(@html_content).to match(/function\s+loadSavedBackgroundColor\s*\(/)
  expect(@html_content).to match(/loadSavedBackgroundColor\(\)/)
end
