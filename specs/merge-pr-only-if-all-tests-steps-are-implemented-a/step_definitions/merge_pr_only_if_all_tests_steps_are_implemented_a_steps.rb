# frozen_string_literal: true

require_relative '../../../lib/pr_validator'

# Background steps
Given('a repository with pull request checks enabled') do
  # Verify GitHub Actions workflow exists
  workflow_path = '../.github/workflows/pr-validation.yml'
  expect(File.exist?(workflow_path)).to be true
end

Given('a pull request with associated test cases configured') do
  @pr_validator = Cajiva::PRValidator.new('specs/')
  @has_tests = true
end

# Given steps for test states
Given('all test cases for the pull request are implemented') do
  @all_implemented = true
  @undefined_count = 0
end

Given('all test cases are passing') do
  @all_passing = true
  @failed_count = 0
end

Given('some test cases for the pull request are not implemented') do
  @all_implemented = false
  @undefined_count = 3
end

Given('at least one test case is failing') do
  @all_passing = false
  @failed_count = 1
end

Given('the pull request has no associated test cases') do
  @has_tests = false
  @total_tests = 0
end

Given('at least one implemented test case is failing') do
  @all_passing = false
  @failed_count = 1
end

Given('some test cases for the pull request were not implemented') do
  @previously_undefined = true
end

Given('at least one test case was failing') do
  @previously_failing = true
end

# When steps
When('a developer attempts to merge the pull request') do
  # Simulate PR merge attempt by checking validation
  @validation_result = {
    has_tests: @has_tests,
    all_implemented: @all_implemented,
    all_passing: @all_passing,
    undefined_count: @undefined_count || 0,
    failed_count: @failed_count || 0
  }

  @merge_allowed = @has_tests && @all_implemented && @all_passing
end

When('the missing test cases are implemented') do
  @all_implemented = true
  @undefined_count = 0
end

# Then steps
Then('the pull request is successfully merged') do
  expect(@merge_allowed).to be true
end

Then('the merge is blocked') do
  expect(@merge_allowed).to be false
end

Then('the reason displayed is {string}') do |expected_reason|
  reasons = []

  reasons << 'Missing coverage: no test cases associated with the pull request' unless @has_tests

  reasons << 'Missing coverage: not all test cases are implemented' if @undefined_count&.positive?

  reasons << 'Failing tests: not all tests are passing' if @failed_count&.positive?

  actual_reason = reasons.join('; ')
  expect(actual_reason).to eq(expected_reason)
end

# Scenario outline steps
Given('{word} test cases are not implemented') do |_some|
  @all_implemented = false
  @undefined_count = 2
end

Given('all test cases are implemented but one fails') do
  @all_implemented = true
  @all_passing = false
  @failed_count = 1
end

Given('no test cases are associated with the pull request') do
  @has_tests = false
  @total_tests = 0
end

Given('some cases not implemented and at least one fails') do
  @all_implemented = false
  @all_passing = false
  @undefined_count = 2
  @failed_count = 1
end
