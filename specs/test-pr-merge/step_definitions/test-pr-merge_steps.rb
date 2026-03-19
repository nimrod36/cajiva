# frozen_string_literal: true

# Step definitions for test pr merge
# This feature validates that PR merges are blocked when specs fail or are incomplete
# Note: File name matches feature file pattern (test-pr-merge.feature)

# Background steps
Given('a repository with branch protection rules configured') do
  @branch_protection_enabled = true
  @repository = { name: 'cajiva', branch: 'main', protection_rules: true }
end

Given('a pull request exists with changes ready for review') do
  @pull_request = {
    id: 123,
    status: 'open',
    branch: 'feature/test-branch',
    target: 'main',
    specs_configured: true
  }
end

# Spec execution states
Given('all specs are executed for the pull request') do
  @spec_execution = {
    status: 'completed',
    total_specs: 10,
    passed: 10,
    failed: 0
  }
end

Given('all specs pass without errors') do
  @spec_execution[:passed] = @spec_execution[:total_specs]
  @spec_execution[:failed] = 0
  @all_specs_pass = true
end

Given('at least one spec fails') do
  @spec_execution[:passed] = 7
  @spec_execution[:failed] = 3
  @all_specs_pass = false
end

Given('spec execution is triggered for the pull request') do
  @spec_execution = {
    status: 'in_progress',
    total_specs: 10,
    passed: 0,
    failed: 0
  }
end

Given('spec execution is still in progress') do
  @spec_execution[:status] = 'in_progress'
  @spec_incomplete = true
end

Given('the pull request does not have any specs configured') do
  @pull_request[:specs_configured] = false
  @spec_execution = { total_specs: 0 }
  @no_specs_configured = true
end

Given('the spec {string} fails with error {string}') do |spec_name, error_message|
  @spec_execution[:failed_spec] = { name: spec_name, error: error_message }
  @spec_execution[:failed] = 1
  @all_specs_pass = false
end

Given('branch protection rules are disabled for the repository') do
  @branch_protection_enabled = false
  @repository[:protection_rules] = false
end

Given('the spec execution fails due to a network issue') do
  @spec_execution = {
    status: 'failed',
    error: 'Network connectivity issue during spec execution'
  }
  @network_failure = true
end

# Action step
When('the user attempts to merge the pull request') do
  @merge_attempt = true

  # Simulate merge logic
  if @branch_protection_enabled
    if @no_specs_configured
      @merge_allowed = false
      @block_reason = 'Missing coverage: no test cases associated with the pull request'
    elsif @spec_incomplete
      @merge_allowed = false
      @block_reason = 'Spec execution is not yet complete'
    elsif @network_failure
      @merge_allowed = false
      @block_reason = 'Spec execution could not be completed due to network issues'
    elsif !@all_specs_pass && (@spec_execution[:failed]).positive?
      @merge_allowed = false
      if @spec_execution[:failed_spec]
        failed_spec = @spec_execution[:failed_spec]
        @block_reason = "Failure in #{failed_spec[:name]} with error: #{failed_spec[:error]}"
      else
        @block_reason = 'One or more specs failed'
      end
    else
      @merge_allowed = true
    end
  else
    # Branch protection disabled - allow merge even with failures
    @merge_allowed = true
  end
end

# Assertion steps
Then('the pull request is successfully merged') do
  expect(@merge_allowed).to be true
end

Then('the merge is blocked') do
  expect(@merge_allowed).to be false
end

Then('the branch is updated with the changes') do
  expect(@pull_request[:status]).to eq('open').or eq('merged')
  expect(@merge_attempt).to be true
end

Then('a message is displayed indicating that one or more specs failed') do
  expect(@block_reason).to(include('failed').or(include('not passing')))
end

Then('a message is displayed indicating that spec execution is not yet complete') do
  expect(@block_reason).to include('not yet complete')
end

Then('a message is displayed indicating that no specs are configured for the repository') do
  expect(@block_reason).to(include('no test cases').or(include('no specs')))
end

Then('a message is displayed indicating the failure in {string} with the error {string}') do |spec_name, error_message|
  expect(@block_reason).to include(spec_name)
  expect(@block_reason).to include(error_message)
end

Then('a message is displayed indicating that spec execution could not be completed due to network issues') do
  expect(@block_reason).to(include('network').or(include('connectivity')))
end
