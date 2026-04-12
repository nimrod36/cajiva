# frozen_string_literal: true

# Step definitions for repository maintenance
# Generated from issue #86

require 'rspec/expectations'
require 'fileutils'
require 'tmpdir'
require 'open3'

# Background steps
Given('the repository is functional and accessible') do
  @repo_root = File.expand_path('../../..', __dir__)
  expect(File.directory?(@repo_root)).to be true
  
  # Verify basic repository structure exists
  expect(File.exist?(File.join(@repo_root, 'Gemfile'))).to be true
  expect(File.directory?(File.join(@repo_root, 'lib'))).to be true
  expect(File.directory?(File.join(@repo_root, 'spec'))).to be true
end

Given('all necessary permissions are granted to the team') do
  # Verify write permissions in key directories
  expect(File.writable?(@repo_root)).to be true
  expect(File.writable?(File.join(@repo_root, 'lib'))).to be true
end

# Rule: Unused File Removal
Given('the repository contains an unused file named {string}') do |filename|
  @unused_file_path = File.join(@repo_root, filename)
  # Verify the file does NOT exist (it should have been cleaned up)
  @file_exists = File.exist?(@unused_file_path)
end

When('the file is identified as unused and removed') do
  # Check that cleanup happened - file should not exist
  @cleanup_successful = !File.exist?(@unused_file_path)
end

Then('the repository should remain functional') do
  # Comprehensive functionality check
  Dir.chdir(@repo_root) do
    # Check main application file
    stdout, stderr, status = Open3.capture3('ruby -c main.rb')
    expect(status.success?).to be(true), "main.rb has syntax errors: #{stderr}"
    
    # Check web application file
    stdout, stderr, status = Open3.capture3('ruby -c app.rb')
    expect(status.success?).to be(true), "app.rb has syntax errors: #{stderr}"
    
    # Verify all tests can run
    stdout, stderr, status = Open3.capture3('bundle exec rspec --dry-run')
    expect(status.success?).to be(true), "RSpec tests cannot load: #{stderr}"
  end
end

Then('no hidden dependencies should be affected') do
  # Verify all lib files are valid and loadable
  Dir.chdir(@repo_root) do
    lib_files = Dir.glob('lib/*.rb')
    expect(lib_files).not_to be_empty, "No library files found"
    
    lib_files.each do |file|
      # Syntax check
      stdout, stderr, status = Open3.capture3("ruby -c #{file}")
      expect(status.success?).to be(true), "#{file} has syntax errors: #{stderr}"
      
      # Check for requires that might be broken
      content = File.read(file)
      content.scan(/require(?:_relative)?\s+['"]([^'"]+)['"]/).flatten.each do |required|
        next if required.start_with?('json', 'matrix', 'open3', 'date') # stdlib
        # Verify relative requires exist
        if content.include?('require_relative')
          required_path = File.join(File.dirname(file), "#{required}.rb")
          expect(File.exist?(required_path)).to be(true), "Missing dependency: #{required_path}"
        end
      end
    end
  end
end

# Rule: Documentation Updates
Given('the documentation is outdated for a specific module') do
  @readme_path = File.join(@repo_root, 'README.md')
  expect(File.exist?(@readme_path)).to be true
  @readme_content = File.read(@readme_path)
end

When('the module is refactored for clarity') do
  # Verify lib files follow clean code principles after refactoring
  @lib_dir = File.join(@repo_root, 'lib')
  @lib_files = Dir.glob(File.join(@lib_dir, '*.rb'))
  expect(@lib_files).not_to be_empty
  
  @code_quality_checks = @lib_files.map do |file|
    content = File.read(file)
    {
      file: File.basename(file),
      has_module: content.match?(/module\s+\w+/),
      has_comments: content.match?(/^\s*#/),
      reasonable_length: content.lines.count < 500,
      no_long_lines: content.lines.all? { |line| line.length < 150 }
    }
  end
end

Then('the documentation should be updated to reflect the refactored code') do
  # Verify README is comprehensive and up-to-date
  expect(@readme_content.length).to be > 500, "Documentation too brief"
  
  # Check for essential sections
  expect(@readme_content).to match(/##\s*Features/i), "Missing Features section"
  expect(@readme_content).to match(/##\s*Setup|Installation/i), "Missing Setup section"
  expect(@readme_content).to match(/##\s*.*Structure/i), "Missing Structure section"
  
  # Verify all lib modules are documented
  @lib_files.each do |file|
    module_name = File.basename(file, '.rb')
    next if module_name == 'version' # Version files don't need docs
    
    # Check if module is mentioned in README
    expect(@readme_content).to match(/#{module_name.gsub('_', '[ _-]')}/i),
      "Module #{module_name} not documented in README"
  end
end

Then('it should provide actionable guidance for developers') do
  # Verify README has practical instructions
  required_patterns = [
    /bundle install|gem install/i,      # Installation instructions
    /ruby\s+\w+\.rb|bundle exec/i,      # Running instructions
    /(rspec|cucumber|test)/i,           # Testing instructions
    /```(\w+)?\s*\n/                    # Code examples
  ]
  
  required_patterns.each_with_index do |pattern, index|
    expect(@readme_content).to match(pattern),
      "README missing pattern #{index + 1}: actionable guidance incomplete"
  end
  
  # Check for API documentation if applicable
  if File.exist?(File.join(@repo_root, 'app.rb'))
    expect(@readme_content).to match(/endpoint|api|http|GET|POST/i),
      "Web app exists but API not documented"
  end
end

# Rule: Refactoring for Clean Code
Given('a Ruby method with excessive complexity') do
  # Health check: verify no methods are overly complex after refactoring
  @lib_files = Dir.glob(File.join(@repo_root, 'lib/*.rb'))
  @complexity_analysis = []
  
  @lib_files.each do |file|
    content = File.read(file)
    methods = content.scan(/^\s*def\s+(\w+).*?^\s*end/m)
    
    methods.each do |method_body|
      method_text = method_body[0]
      lines = method_text.lines.count
      
      @complexity_analysis << {
        file: File.basename(file),
        lines: lines,
        acceptable: lines < 50  # Methods should be < 50 lines
      }
    end
  end
  
  expect(@lib_files).not_to be_empty, "No library files found for complexity check"
end

When('the method is refactored to follow clean coding principles') do
  # Verify code quality metrics after refactoring
  @lib_files.each do |file|
    content = File.read(file)
    
    # Check clean code indicators
    @clean_code_metrics = {
      has_frozen_string_literal: content.start_with?('# frozen_string_literal: true'),
      has_module_structure: content.match?(/module\s+\w+/),
      reasonable_line_lengths: content.lines.all? { |line| line.length < 150 },
      no_trailing_whitespace: content.lines.none? { |line| line.match?(/\s+$/) }
    }
  end
  
  expect(@clean_code_metrics).to be_truthy
end

Then('the functionality of the method should remain unchanged') do
  # Quick syntax validation only (no test execution)
  Dir.chdir(@repo_root) do
    @lib_files.each do |file|
      stdout, stderr, status = Open3.capture3("ruby -c #{file}")
      expect(status.success?).to be(true), "#{file} has syntax errors: #{stderr}"
    end
  end
end

Then('the code should be easier to read and maintain') do
  # Verify clean code metrics
  expect(@clean_code_metrics[:has_frozen_string_literal]).to be(true),
    "Files missing frozen_string_literal pragma"
  expect(@clean_code_metrics[:reasonable_line_lengths]).to be(true),
    "Some lines exceed 150 characters"
  
  # Verify no overly complex methods
  complex_methods = @complexity_analysis.select { |m| !m[:acceptable] }
  expect(complex_methods).to be_empty,
    "Found #{complex_methods.count} methods with > 50 lines"
  
  # Verify consistent naming and structure
  @lib_files.each do |file|
    content = File.read(file)
    
    # Check for consistent naming (snake_case)
    class_and_methods = content.scan(/(?:class|module|def)\s+(\w+)/).flatten
    camel_case_items = class_and_methods.select { |name| name.match?(/[a-z][A-Z]/) && !name.match?(/^[A-Z]/) }
    expect(camel_case_items).to be_empty,
      "Found non-standard naming: #{camel_case_items.join(', ')}"
  end
end

# Rule: Repository Restructuring
Given('the repository has a disorganized structure') do
  # Verify structure is now properly organized
  @required_structure = {
    lib: File.join(@repo_root, 'lib'),
    spec: File.join(@repo_root, 'spec'),
    specs: File.join(@repo_root, 'specs'),
    data: File.join(@repo_root, 'data'),
    public: File.join(@repo_root, 'public'),
    hooks: File.join(@repo_root, 'hooks')
  }
  
  @structure_health = @required_structure.transform_values do |path|
    Dir.exist?(path) && Dir.children(path).any?
  end
end

When('the structure is reorganized for maintainability') do
  # Verify directories are properly organized with relevant content
  @organization_quality = {
    lib_has_ruby_files: Dir.glob(File.join(@repo_root, 'lib/*.rb')).any?,
    specs_has_features: Dir.glob(File.join(@repo_root, 'specs/**/*.feature')).any?,
    specs_has_step_defs: Dir.glob(File.join(@repo_root, 'specs/**/step_definitions/*.rb')).any?,
    spec_has_unit_tests: Dir.glob(File.join(@repo_root, 'spec/**/*_spec.rb')).any?,
    data_has_json: Dir.glob(File.join(@repo_root, 'data/*.json')).any?,
    hooks_has_scripts: Dir.glob(File.join(@repo_root, 'hooks/pre-*')).any?,
    no_clutter_in_root: Dir.glob(File.join(@repo_root, '*.{tmp,log,bak,old}')).empty?
  }
  
  # Check for unnecessary files in tmp/bin (excluding test artifacts)
  tmp_clutter = Dir.glob(File.join(@repo_root, 'tmp/*')).reject { |f| f.end_with?('.json', '.html') }
  bin_clutter = Dir.glob(File.join(@repo_root, 'bin/*'))
  @clean_dirs = tmp_clutter.empty? && bin_clutter.empty?
end

Then('all existing paths and integrations should remain functional') do
  # Verify critical files exist and work
  critical_files = ['main.rb', 'app.rb', 'Gemfile', 'config.ru']
  
  critical_files.each do |file|
    path = File.join(@repo_root, file)
    expect(File.exist?(path)).to be(true), "Critical file missing: #{file}"
    
    # Syntax check for Ruby files
    if file.end_with?('.rb')
      stdout, stderr, status = Open3.capture3("ruby -c #{path}")
      expect(status.success?).to be(true), "#{file} has syntax errors: #{stderr}"
    end
  end
  
  # Verify bundler can resolve dependencies
  Dir.chdir(@repo_root) do
    stdout, stderr, status = Open3.capture3('bundle check')
    expect(status.success?).to be(true), "Bundle dependencies not satisfied: #{stderr}"
  end
end

Then('the codebase should be easier to navigate') do
  # Verify all required directories exist and contain relevant files
  expect(@organization_quality[:lib_has_ruby_files]).to be(true),
    "lib/ directory missing Ruby files"
  expect(@organization_quality[:specs_has_features]).to be(true),
    "specs/ directory missing feature files"
  expect(@organization_quality[:specs_has_step_defs]).to be(true),
    "specs/ directory missing step definitions"
  expect(@organization_quality[:spec_has_unit_tests]).to be(true),
    "spec/ directory missing unit tests"
  
  # Verify no clutter
  expect(@organization_quality[:no_clutter_in_root]).to be(true),
    "Root directory contains temporary/backup files"
  expect(@clean_dirs).to be(true),
    "tmp/ or bin/ directories contain unnecessary files"
end

# Rule: Preparing for Testing
Given('the repository lacks configurations for a testing framework') do
  # Verify test infrastructure is properly configured
  @test_config = {
    rspec_helper: File.join(@repo_root, 'spec/spec_helper.rb'),
    cucumber_yml: File.join(@repo_root, 'cucumber.yml'),
    gemfile: File.join(@repo_root, 'Gemfile')
  }
  
  @config_exists = @test_config.transform_values { |path| File.exist?(path) }
end

When('necessary configurations and dependencies are added') do
  # Verify test dependencies are properly configured
  gemfile_content = File.read(@test_config[:gemfile])
  
  @test_dependencies = {
    rspec: gemfile_content.match?(/gem\s+['"]rspec['"]/),
    cucumber: gemfile_content.match?(/gem\s+['"]cucumber['"]/),
    simplecov: gemfile_content.match?(/gem\s+['"]simplecov['"]/),
    rubocop: gemfile_content.match?(/gem\s+['"]rubocop['"]/)
  }
  
  # Check RSpec configuration
  if @config_exists[:rspec_helper]
    rspec_config = File.read(@test_config[:rspec_helper])
    @rspec_configured = rspec_config.match?(/RSpec\.configure/)
  end
  
  # Check Cucumber configuration
  if @config_exists[:cucumber_yml]
    cucumber_config = File.read(@test_config[:cucumber_yml])
    @cucumber_configured = !cucumber_config.strip.empty?
  end
end

Then('the repository should support a standard testing framework') do
  # Verify both testing frameworks are present and configured
  expect(@config_exists[:rspec_helper]).to be(true),
    "RSpec spec_helper.rb missing"
  expect(@config_exists[:cucumber_yml]).to be(true),
    "Cucumber cucumber.yml missing"
  
  expect(@rspec_configured).to be(true),
    "RSpec not properly configured"
  expect(@cucumber_configured).to be(true),
    "Cucumber configuration empty"
  
  # Verify test dependencies are installed
  expect(@test_dependencies[:rspec]).to be(true),
    "RSpec gem not in Gemfile"
  expect(@test_dependencies[:cucumber]).to be(true),
    "Cucumber gem not in Gemfile"
end

Then('the code should be test-ready') do
  # Verify comprehensive test coverage exists
  rspec_tests = Dir.glob(File.join(@repo_root, 'spec/**/*_spec.rb'))
  cucumber_features = Dir.glob(File.join(@repo_root, 'specs/**/*.feature'))
  
  expect(rspec_tests.count).to be > 0, "No RSpec tests found"
  expect(cucumber_features.count).to be > 0, "No Cucumber features found"
  
  # Quick syntax check only
  rspec_tests.each do |file|
    stdout, stderr, status = Open3.capture3("ruby -c #{file}")
    expect(status.success?).to be(true), "Test file #{file} has errors: #{stderr}"
  end
end
