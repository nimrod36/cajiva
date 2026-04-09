# frozen_string_literal: true

require 'rspec/expectations'
require 'fileutils'
require 'tmpdir'
require 'open3'

# Background steps

Given('the repository has a valid {string} directory') do |dir_name|
  @test_repo_dir = Dir.mktmpdir('git-hooks-test')
  @git_dir = File.join(@test_repo_dir, dir_name)
  FileUtils.mkdir_p(@git_dir)
  FileUtils.mkdir_p(File.join(@git_dir, 'hooks'))
end

Given('the hooks library contains {string} and {string} scripts') do |hook1, hook2|
  @hooks_lib_dir = File.join(@test_repo_dir, 'hooks')
  FileUtils.mkdir_p(@hooks_lib_dir)
  
  # Create mock hook scripts
  File.write(File.join(@hooks_lib_dir, hook1), "#!/bin/bash\necho 'pre-commit hook'\n")
  File.write(File.join(@hooks_lib_dir, hook2), "#!/bin/bash\necho 'pre-push hook'\n")
  
  @expected_hooks = [hook1, hook2]
end

# Scenario: Install Git hooks in a repository with no existing hooks

Given('the {string} directory exists') do |dir_path|
  # Already created in background
  target_dir = File.join(@test_repo_dir, dir_path)
  expect(Dir.exist?(target_dir)).to be true
end

Given('the user has write permissions to the {string} directory') do |dir_path|
  target_dir = File.join(@test_repo_dir, dir_path)
  expect(File.writable?(target_dir)).to be true
end

When('the user runs the installation script') do
  # Create a test version of the installer script in the test repo
  installer_script = File.join(@test_repo_dir, 'install-hooks.sh')
  
  # Copy and modify the installer script to work with test directories
  original_script = File.read(File.join(Dir.pwd, 'install-hooks.sh'))
  
  # Replace paths to use test directories
  test_script = original_script.gsub(
    'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
    "SCRIPT_DIR=\"#{@test_repo_dir}\""
  )
  
  File.write(installer_script, test_script)
  FileUtils.chmod(0755, installer_script)
  
  # Run the installer script
  if @should_confirm_overwrite
    stdout, stderr, status = Open3.capture3("yes | #{installer_script}")
  elsif @should_abort
    stdout, stderr, status = Open3.capture3(installer_script)
  else
    stdout, stderr, status = Open3.capture3(installer_script)
  end
  
  @install_output = stdout + stderr
  @install_status = status
end

Then('the {string} and {string} hooks should be copied to the {string} directory') do |hook1, hook2, target_dir|
  target_path = File.join(@test_repo_dir, target_dir)
  
  hook1_path = File.join(target_path, hook1)
  hook2_path = File.join(target_path, hook2)
  
  expect(File.exist?(hook1_path)).to be true
  expect(File.exist?(hook2_path)).to be true
end

Then('the copied hooks should be made executable') do
  target_dir = File.join(@test_repo_dir, '.git/hooks')
  
  @expected_hooks.each do |hook|
    hook_path = File.join(target_dir, hook)
    expect(File.executable?(hook_path)).to be true
  end
end

# Scenario: Overwrite existing hooks with confirmation

Given('the {string} directory contains an existing {string} hook') do |dir_path, hook_name|
  target_dir = File.join(@test_repo_dir, dir_path)
  existing_hook = File.join(target_dir, hook_name)
  File.write(existing_hook, "#!/bin/bash\necho 'old hook'\n")
  FileUtils.chmod(0755, existing_hook)
  
  @should_confirm_overwrite = true
end

When('confirms to overwrite the existing hooks') do
  @should_confirm_overwrite = true
end

# Scenario: Abort installation when .git directory is missing

Given('the repository does not contain a {string} directory') do |dir_name|
  @test_repo_dir = Dir.mktmpdir('git-hooks-no-git')
  @hooks_lib_dir = File.join(@test_repo_dir, 'hooks')
  FileUtils.mkdir_p(@hooks_lib_dir)
  
  # Create mock hook scripts
  File.write(File.join(@hooks_lib_dir, 'pre-commit'), "#!/bin/bash\necho 'hook'\n")
  File.write(File.join(@hooks_lib_dir, 'pre-push'), "#!/bin/bash\necho 'hook'\n")
  
  @should_abort = true
  @git_dir = File.join(@test_repo_dir, dir_name)
  expect(Dir.exist?(@git_dir)).to be false
end

Then('the script should abort with a clear error message') do
  expect(@install_status.exitstatus).not_to eq(0)
  expect(@install_output).to match(/ERROR/i)
end

Then('no changes should be made to the repository') do
  # Verify no hooks were installed
  if Dir.exist?(File.join(@test_repo_dir, '.git/hooks'))
    hooks_dir = File.join(@test_repo_dir, '.git/hooks')
    installed_hooks = Dir.glob(File.join(hooks_dir, '*')).select { |f| File.file?(f) }
    expect(installed_hooks).to be_empty
  end
end

# Scenario: Abort installation when hooks library is not accessible

Given('the hooks library does not contain {string} and {string} scripts') do |hook1, hook2|
  @test_repo_dir = Dir.mktmpdir('git-hooks-no-lib')
  @git_dir = File.join(@test_repo_dir, '.git')
  FileUtils.mkdir_p(File.join(@git_dir, 'hooks'))
  
  # Create hooks directory but don't add the required scripts
  @hooks_lib_dir = File.join(@test_repo_dir, 'hooks')
  FileUtils.mkdir_p(@hooks_lib_dir)
  
  @should_abort = true
end

# Scenario: Abort installation when permissions are insufficient

Given('the user does not have write permissions to the {string} directory') do |dir_path|
  @test_repo_dir = Dir.mktmpdir('git-hooks-no-perms')
  @git_dir = File.join(@test_repo_dir, '.git')
  FileUtils.mkdir_p(File.join(@git_dir, 'hooks'))
  
  # Create hooks library
  @hooks_lib_dir = File.join(@test_repo_dir, 'hooks')
  FileUtils.mkdir_p(@hooks_lib_dir)
  File.write(File.join(@hooks_lib_dir, 'pre-commit'), "#!/bin/bash\necho 'hook'\n")
  File.write(File.join(@hooks_lib_dir, 'pre-push'), "#!/bin/bash\necho 'hook'\n")
  
  # Remove write permissions from hooks directory
  target_dir = File.join(@test_repo_dir, dir_path)
  FileUtils.chmod(0555, target_dir)
  
  @should_abort = true
  @cleanup_chmod = target_dir
end

# Cleanup after each scenario
After do
  # Restore permissions if they were changed
  if @cleanup_chmod && Dir.exist?(@cleanup_chmod)
    FileUtils.chmod(0755, @cleanup_chmod)
  end
  
  # Clean up temporary directories
  if @test_repo_dir && Dir.exist?(@test_repo_dir)
    FileUtils.rm_rf(@test_repo_dir)
  end
end
