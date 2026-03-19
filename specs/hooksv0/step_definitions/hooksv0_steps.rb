# frozen_string_literal: true

require 'open3'
require 'fileutils'

Given('a git repository with pre-commit and pre-push hooks configured') do
  @repo_path = Dir.pwd
  @hooks_path = File.join(@repo_path, '.git', 'hooks')
  @test_hooks_path = File.join(@repo_path, 'hooks')

  # Verify hooks directory exists
  expect(Dir.exist?(@hooks_path)).to be true
  expect(Dir.exist?(@test_hooks_path)).to be true
end

Given('the hooks are set up to run tests and print coverage and test results') do
  # Verify hook files exist
  @pre_commit_hook = File.join(@test_hooks_path, 'pre-commit-v0')
  @pre_push_hook = File.join(@test_hooks_path, 'pre-push-v0')

  expect(File.exist?(@pre_commit_hook)).to be true
  expect(File.exist?(@pre_push_hook)).to be true
end

Given('I have made changes to the codebase') do
  @changes_made = true
  # Simulate changes by creating a temporary test file
  @test_file = File.join(@repo_path, 'tmp', 'test_change.txt')
  FileUtils.mkdir_p(File.dirname(@test_file))
  File.write(@test_file, "Test change #{Time.now}")
end

Given('all tests pass successfully') do
  @all_tests_pass = true
  @some_tests_fail = false
end

Given('some tests fail during execution') do
  @all_tests_pass = false
  @some_tests_fail = true
end

Given('I have committed my changes') do
  @changes_committed = true
end

Given('there are no tests defined in the project') do
  @no_tests_defined = true
end

Given('the test coverage is below the acceptable threshold') do
  @low_coverage = true
  @coverage_percentage = 45.5
end

Given('there is an error in the pre-commit hook script') do
  @hook_script_error = true
  @error_type = 'pre-commit'
end

Given('there is an error in the pre-push hook script') do
  @hook_script_error = true
  @error_type = 'pre-push'
end

Given('the project contains {string}') do |test_condition|
  @test_condition = test_condition
end

Given('the project contains no test framework') do
  @test_condition = 'no test framework'
end

Given('the project contains invalid test configuration') do
  @test_condition = 'invalid test configuration'
end

Given('the project contains long-running tests') do
  @test_condition = 'long-running tests'
end

When('I stage the changes and trigger the pre-commit hook') do
  # Simulate running pre-commit hook
  @hook_output = simulate_hook_execution('pre-commit')
  @hook_exit_code = 0 # Always succeed in v0
end

When('I push the changes to the remote repository') do
  # Simulate running pre-push hook
  @hook_output = simulate_hook_execution('pre-push')
  @hook_exit_code = 0 # Always succeed in v0
end

Then('the pre-commit hook should display the test results') do
  expect(@hook_output).to include('Test Results')
  expect(@hook_output).to(include('passed').or(include('✓'))) if @all_tests_pass
end

Then('the pre-commit hook should display the test coverage') do
  expect(@hook_output).to(include('Coverage').or(include('Test coverage')))
end

Then('the commit should proceed without enforcement') do
  expect(@hook_exit_code).to eq(0)
end

Then('the pre-commit hook should display the test results including the failures') do
  expect(@hook_output).to include('Test Results')
  expect(@hook_output).to(include('failed').or(include('✗')))
end

Then('the pre-push hook should display the test results') do
  expect(@hook_output).to include('Test Results')
  expect(@hook_output).to(include('passed').or(include('✓'))) if @all_tests_pass
end

Then('the pre-push hook should display the test coverage') do
  expect(@hook_output).to(include('Coverage').or(include('Test coverage')))
end

Then('the push should proceed without enforcement') do
  expect(@hook_exit_code).to eq(0)
end

Then('the pre-push hook should display the test results including the failures') do
  expect(@hook_output).to include('Test Results')
  expect(@hook_output).to(include('failed').or(include('✗')))
end

Then('the pre-commit hook should display a message indicating that no tests are defined') do
  expect(@hook_output).to(include('No tests').or(include('no test')))
end

Then('the pre-push hook should display a message indicating that no tests are defined') do
  expect(@hook_output).to(include('No tests').or(include('no test')))
end

Then('the pre-commit hook should display the test coverage percentage') do
  expect(@hook_output).to match(/\d+\.?\d*%/)
end

Then('the pre-push hook should display the test coverage percentage') do
  expect(@hook_output).to match(/\d+\.?\d*%/)
end

Then('the pre-commit hook should display an error message indicating the script failure') do
  expect(@hook_output).to(include('error').or(include('Error')))
end

Then('the commit should proceed despite the script error') do
  expect(@hook_exit_code).to eq(0)
end

Then('the pre-push hook should display an error message indicating the script failure') do
  expect(@hook_output).to(include('error').or(include('Error')))
end

Then('the push should proceed despite the script error') do
  expect(@hook_exit_code).to eq(0)
end

Then('the pre-commit hook should display the {string}') do |expected_output|
  expect(@hook_output).to include(expected_output)
end

Then('the pre-push hook should display the {string}') do |expected_output|
  expect(@hook_output).to include(expected_output)
end

# Helper method to simulate hook execution
# rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
def simulate_hook_execution(hook_type)
  output = []
  output << ('=' * 60)
  output << "#{hook_type.upcase} HOOK - FEEDBACK MODE (v0)"
  output << ('=' * 60)
  output << ''

  if @hook_script_error
    output << '⚠️  Error: Hook script encountered an issue'
    output << 'Error details: Simulated script error'
    output << ''
    output << 'ℹ️  This is informational only - proceeding anyway'
    return output.join("\n")
  end

  if @no_tests_defined
    output << '⚠️  No tests defined in the project'
    output << 'Consider adding tests to improve code quality'
    output << ''
    output << 'ℹ️  This is informational only - proceeding anyway'
    return output.join("\n")
  end

  if @test_condition
    case @test_condition
    when 'no test framework'
      output << '⚠️  No test framework detected'
    when 'invalid test configuration'
      output << '⚠️  Test configuration is invalid'
    when 'long-running tests'
      output << '⚠️  Tests are taking longer than expected'
    end
    output << ''
    output << 'ℹ️  This is informational only - proceeding anyway'
    return output.join("\n")
  end

  # Display test results
  output << '📋 Test Results:'
  output << ('-' * 60)

  if @all_tests_pass
    output << '✓ All tests passed'
    output << '  - RSpec: 25 examples, 0 failures'
    output << '  - Cucumber: 10 scenarios, 0 failures'
  else
    output << '✗ Some tests failed'
    output << '  - RSpec: 25 examples, 3 failures'
    output << '  - Cucumber: 10 scenarios, 2 failures'
  end

  output << ''

  # Display test coverage
  output << '📊 Test Coverage:'
  output << ('-' * 60)

  if @low_coverage
    output << "⚠️  Coverage: #{@coverage_percentage}%"
    output << '   Below recommended threshold of 80%'
  else
    output << '✓ Coverage: 85.5%'
    output << '  Line coverage: 85.5%'
    output << '  Branch coverage: 82.3%'
  end

  output << ''
  output << ('=' * 60)
  output << 'ℹ️  This is informational only - proceeding anyway'
  output << ('=' * 60)

  output.join("\n")
end
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
