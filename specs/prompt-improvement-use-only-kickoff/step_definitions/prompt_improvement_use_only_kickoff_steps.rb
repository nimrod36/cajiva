# frozen_string_literal: true

require 'yaml'

# Step definitions for prompt improvement - use only kickoff workflow
# This feature ensures generate-test-plan.yml is removed and only
# kickoff-feature-automation.yml handles issue automation

Given('the kickoff workflow exists at {string}') do |workflow_path|
  @workflow_path = workflow_path
  expect(File.exist?(@workflow_path)).to be true
end

Given('a new GitHub issue is created') do
  @issue_created = true
  @issue_event = 'opened'
end

When('the issue event is processed') do
  # Verify workflow configuration would trigger
  workflow_content = File.read(@workflow_path)
  @workflow_config = YAML.safe_load(workflow_content, permitted_classes: [Symbol], aliases: true)
end

Then('the kickoff-feature-automation workflow should be triggered') do
  # The YAML parser converts 'on' to boolean true
  issue_types = @workflow_config.dig(true, 'issues', 'types') || @workflow_config.dig('on', 'issues', 'types')
  expect(issue_types).to include('opened')
end

Then('the generate-test-plan workflow should not exist') do
  old_workflow_path = '.github/workflows/generate-test-plan.yml'
  expect(File.exist?(old_workflow_path)).to be false
end

Given('I check the workflows directory') do
  @workflows_dir = '.github/workflows'
  @workflow_files = Dir.glob("#{@workflows_dir}/*.yml")
end

Then('only {string} should be present for issue automation') do |expected_workflow|
  # Filter workflows that trigger on issue opened/reopened for test plan generation
  # Exclude auto-create-feature-pr and linear-webhook-handler which serve different purposes
  issue_workflows = @workflow_files.select do |file|
    next if file.include?('auto-create-feature-pr') || file.include?('linear-webhook-handler')

    content = File.read(file)
    config = YAML.safe_load(content, permitted_classes: [Symbol], aliases: true)

    # Check if it handles issue events for test plan generation
    # Note: 'on' is parsed as boolean true by YAML
    issue_types = config.dig(true, 'issues', 'types') || config.dig('on', 'issues', 'types')
    issue_types&.include?('opened') && (content.include?('test plan') || content.include?('BDD'))
  end

  expect(issue_workflows.length).to eq(1)
  expect(issue_workflows.first).to include(expected_workflow)
end

Then('{string} should not exist') do |workflow_name|
  workflow_path = File.join(@workflows_dir, workflow_name)
  expect(File.exist?(workflow_path)).to be false
end

Given('a new feature issue is opened with title and description') do
  @issue = {
    title: 'Test Feature',
    body: 'Feature description',
    event: 'opened'
  }
end

When('the kickoff workflow executes') do
  @workflow_content = File.read(@workflow_path)
end

Then('it should read the kickoff-feature prompt') do
  expect(@workflow_content).to include('.github/prompts/kickoff-feature.prompt.md')
end

Then('it should read the create-test-plan prompt') do
  expect(@workflow_content).to include('.github/prompts/create-test-plan.prompt.md')
end

Then('it should generate a comprehensive BDD test plan') do
  # Workflow should contain logic for test plan generation
  expect(@workflow_content).to include('BDD')
end

Then('it should comment the plan on the issue') do
  # Workflow should use github-script to comment
  expect(@workflow_content).to include('github-script')
end

Given('the kickoff workflow configuration is loaded') do
  @workflow_content = File.read(@workflow_path)
  @workflow_config = YAML.safe_load(@workflow_content, permitted_classes: [Symbol], aliases: true)
end

Then('it should trigger on {string} issue events') do |event_type|
  # NOTE: 'on' is parsed as boolean true by YAML
  issue_types = @workflow_config.dig(true, 'issues', 'types') || @workflow_config.dig('on', 'issues', 'types')
  expect(issue_types).to include(event_type)
end

Then('it should not trigger on {string} issue events') do |event_type|
  # NOTE: 'on' is parsed as boolean true by YAML
  issue_types = @workflow_config.dig(true, 'issues', 'types') || @workflow_config.dig('on', 'issues', 'types')
  expect(issue_types).not_to include(event_type)
end

Given('I search for workflow files that handle issue events') do
  @workflows_dir = '.github/workflows'
  @issue_workflows = Dir.glob("#{@workflows_dir}/*.yml").select do |file|
    # Exclude workflows for different purposes (auto PR creation, Linear webhook)
    next if file.include?('auto-create-feature-pr') || file.include?('linear-webhook-handler')

    content = File.read(file)
    config = YAML.safe_load(content, permitted_classes: [Symbol], aliases: true)

    # Only count workflows that handle issue events for test plan generation
    # Note: 'on' is parsed as boolean true by YAML
    issue_types = config.dig(true, 'issues', 'types') || config.dig('on', 'issues', 'types')
    issue_types&.include?('opened') && (content.include?('test plan') || content.include?('BDD'))
  end
end

Then('I should find only {string}') do |expected_workflow|
  expect(@issue_workflows.length).to eq(1)
  expect(@issue_workflows.first).to end_with(expected_workflow)
end

Then('I should not find {string} anywhere') do |workflow_name|
  matching_files = @issue_workflows.select { |file| file.include?(workflow_name) }
  expect(matching_files).to be_empty
end

Then('no other workflow should duplicate test plan generation') do
  test_plan_workflows = @issue_workflows.select do |file|
    content = File.read(file)
    content.include?('test plan') || content.include?('BDD')
  end

  # Only kickoff-feature-automation should handle test plans
  expect(test_plan_workflows.length).to eq(1)
  expect(test_plan_workflows.first).to include('kickoff-feature-automation.yml')
end
