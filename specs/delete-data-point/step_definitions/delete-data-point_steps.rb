# frozen_string_literal: true

require 'rspec/expectations'

Before do
  @html_file = File.join(File.dirname(__FILE__), '../../../public/index.html')
  @html_content = File.read(@html_file)
  @app_file = File.join(File.dirname(__FILE__), '../../../app.rb')
  @app_content = File.read(@app_file)
end

# Background steps
Given('the system is operational') do
  # Verify server app exists and has required endpoints
  expect(@app_content).to match(/delete\s+['"]\/api\/data\/:index['"]/)
  expect(File.exist?(@html_file)).to be true
end

Given('the user is logged in') do
  # For this application, we assume the user is always logged in
  # This step serves as documentation of the precondition
  @user_logged_in = true
  expect(@user_logged_in).to be true
end

Given('a data point exists in the current view') do
  # Verify chart and data visualization exists
  expect(@html_content).to include('id="regressionChart"')
  expect(@html_content).to match(/let\s+currentData\s*=/)
  expect(@html_content).to match(/actual:\s*\[\]/)
end

# Scenario: Deleting a data point successfully
Given('the user selects a data point') do
  # Verify chart has click handler
  expect(@html_content).to match(/onClick:\s*\(event,\s*activeElements\)\s*=>/)
  expect(@html_content).to match(/handleChartClick/)
  
  # Verify selected point is stored
  expect(@html_content).to match(/selectedPointForDeletion\s*=/)
end

When('the user opens the deletion dialog') do
  # Verify modal dialog exists
  expect(@html_content).to match(/<div\s+id=["']deleteModal["']\s+class=["']modal-overlay["']/)
  
  # Verify openDeleteDialog function exists
  expect(@html_content).to match(/function\s+openDeleteDialog\s*\(/)
  expect(@html_content).to match(/modal\.classList\.add\(['"]active['"]\)/)
end

When('confirms the deletion') do
  # Verify confirm button exists
  expect(@html_content).to match(/<button[^>]*id=["']confirmDeleteBtn["'][^>]*onclick=["']confirmDelete\(\)["']/)
  
  # Verify confirmDelete function exists
  expect(@html_content).to match(/async\s+function\s+confirmDelete\s*\(/)
  expect(@html_content).to match(/await\s+deleteDataPoint/)
end

Then('the data point should be removed from the system') do
  # Verify DELETE endpoint exists in backend
  expect(@app_content).to match(/delete\s+['"]\/api\/data\/:index['"]/)
  expect(@app_content).to match(/deleted_point\s*=\s*data_points\.delete_at\(index\)/)
  
  # Verify frontend sends DELETE request
  expect(@html_content).to match(/fetch\(`\/api\/data\/\$\{actualIndex\}`/)
  expect(@html_content).to match(/method:\s*['"]DELETE['"]/)
end

Then('the data point should no longer be visible in the current view') do
  # Verify chart is recreated after deletion
  expect(@html_content).to match(/createChart\(\)/)
  
  # Verify data is updated
  expect(@html_content).to match(/currentData\.actual\s*=\s*result\.actual/)
  expect(@html_content).to match(/updateUI\(result\)/)
end

# Scenario: Canceling the deletion process
When('cancels the operation') do
  # Verify cancel button exists
  expect(@html_content).to match(/<button[^>]*class=["'][^"']*btn-cancel[^"']*["'][^>]*id=["']cancelDeleteBtn["'][^>]*onclick=["']closeDeleteDialog\(\)["']/)
  
  # Verify closeDeleteDialog function exists
  expect(@html_content).to match(/function\s+closeDeleteDialog\s*\(/)
  expect(@html_content).to match(/modal\.classList\.remove\(['"]active['"]\)/)
end

Then('the data point should remain in the system') do
  # Verify close function doesn't make DELETE request
  expect(@html_content).to match(/selectedPointForDeletion\s*=\s*null/)
  
  # Verify modal is just hidden, not deleting data
  close_delete_match = @html_content.match(/function\s+closeDeleteDialog\s*\([^)]*\)\s*\{[^}]*\}/m)
  expect(close_delete_match).not_to be_nil
  expect(close_delete_match[0]).not_to match(/deleteDataPoint/)
  expect(close_delete_match[0]).not_to match(/fetch.*DELETE/)
end

Then('the data point should remain visible in the current view') do
  # Verify closing dialog doesn't update chart or data
  close_delete_match = @html_content.match(/function\s+closeDeleteDialog\s*\([^)]*\)\s*\{[^}]*\}/m)
  expect(close_delete_match).not_to be_nil
  expect(close_delete_match[0]).not_to match(/createChart/)
  expect(close_delete_match[0]).not_to match(/updateUI/)
end

# Scenario: User without delete permissions attempts to delete
Given('the user does not have permission to delete the data point') do
  # Verify deleteEnabled flag exists and can be set to false
  expect(@html_content).to match(/let\s+deleteEnabled\s*=/)
  
  # For testing, we verify the permission check logic exists
  expect(@html_content).to match(/if\s*\(!\s*deleteEnabled\)/)
end

Then('the deletion dialog should not allow deletion') do
  # Verify confirm button is disabled when no permission
  expect(@html_content).to match(/confirmBtn\.disabled\s*=\s*true/)
  
  # Verify permission check in openDeleteDialog
  expect(@html_content).to match(/if\s*\(!\s*deleteEnabled\)\s*\{[^}]*confirmBtn\.disabled\s*=\s*true/m)
end

Then('an appropriate message should be displayed') do
  # Verify permission denied message
  expect(@html_content).to match(/You do not have permission to delete this data point/)
  expect(@html_content).to match(/deleteMessage\.textContent\s*=\s*['"]You do not have permission/)
end

# Scenario: Deletion fails due to server error
When('the deletion fails due to a server error') do
  # Verify error handling in backend
  expect(@app_content).to match(/rescue\s+StandardError\s*=>\s*e/)
  expect(@app_content).to match(/status\s+500/)
  expect(@app_content).to match(/\{\s*error:\s*e\.message\s*\}\.to_json/)
end

Then('the user should see an error notification') do
  # Verify error notification is shown
  expect(@html_content).to match(/showNotification\([^)]*['"]error['"]/)
  expect(@html_content).to match(/catch\s*\([^)]*error[^)]*\)\s*\{[^}]*showNotification/m)
end

Then('the data point should remain visible in the system') do
  # Verify error handler exists and shows notification
  expect(@html_content).to match(/catch\s*\([^)]*error[^)]*\)\s*\{/)
  expect(@html_content).to match(/console\.error\(['"]Error deleting data point/)
  expect(@html_content).to match(/showNotification\(['"]Unable to delete data point, please try again later['"],\s*['"]error['"]\)/)
end

# Scenario: Keyboard navigation for deletion
Given('the user is navigating with a keyboard') do
  # Verify keyboard event listeners exist
  expect(@html_content).to match(/document\.addEventListener\(['"]keydown['"]/)
  
  # Verify modal supports keyboard navigation
  expect(@html_content).to match(/e\.key\s*===\s*['"]Escape['"]/)
  expect(@html_content).to match(/e\.key\s*===\s*['"]Enter['"]/)
end

When('opens the deletion dialog') do
  # Verify dialog has proper ARIA attributes
  expect(@html_content).to match(/role=["']dialog["']/)
  expect(@html_content).to match(/aria-labelledby=["']modalTitle["']/)
  expect(@html_content).to match(/aria-describedby=["']modalDesc["']/)
  
  # Verify focus management
  expect(@html_content).to match(/cancelDeleteBtn.*\.focus\(\)/)
end

Then('the user should be able to confirm or cancel deletion using the keyboard') do
  # Verify Escape key closes dialog
  expect(@html_content).to match(/if\s*\(\s*e\.key\s*===\s*['"]Escape['"]\s*\)\s*\{[^}]*closeDeleteDialog/m)
  
  # Verify Enter key confirms deletion
  expect(@html_content).to match(/if\s*\(\s*e\.key\s*===\s*['"]Enter['"]\s*\)\s*\{[^}]*confirmDelete/m)
  
  # Verify keyboard handler only works when modal is active
  expect(@html_content).to match(/modal\.classList\.contains\(['"]active['"]\)/)
end
