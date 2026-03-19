# frozen_string_literal: true

require 'json'
require 'open3'

module Cajiva
  # Validates that all test cases are implemented and passing for a pull request
  class PRValidator
    class ValidationError < StandardError; end

    attr_reader :undefined_steps, :failed_steps, :passed_steps, :total_steps

    def initialize(specs_path = 'specs/')
      @specs_path = specs_path
      @undefined_steps = []
      @failed_steps = []
      @passed_steps = []
      @total_steps = 0
      @exit_status = nil
      @test_output = ''
      @test_errors = ''
    end

    def validate!
      run_cucumber_tests
      parse_test_results
      generate_validation_result
    end

    def all_tests_implemented?
      @undefined_steps.empty?
    end

    def all_tests_passing?
      @failed_steps.empty?
    end

    def tests?
      @total_steps.positive?
    end

    def validation_message
      return 'All tests implemented and passing' if valid?

      build_failure_reasons.join('; ')
    end

    def valid?
      tests? && all_tests_implemented? && all_tests_passing?
    end

    private

    def build_failure_reasons
      reasons = []
      reasons << 'Missing coverage: no test cases associated with the pull request' unless tests?
      unless all_tests_implemented?
        reasons << "Missing coverage: #{@undefined_steps.length} test step(s) not implemented"
      end
      reasons << "Failing tests: #{@failed_steps.length} test(s) not passing" unless all_tests_passing?
      reasons
    end

    def run_cucumber_tests
      stdout, stderr, status = Open3.capture3(
        'bundle', 'exec', 'cucumber', @specs_path,
        '--strict-undefined',
        '--format', 'json',
        '--out', 'reports/cucumber_report.json'
      )

      @exit_status = status.exitstatus
      @test_output = stdout
      @test_errors = stderr
    end

    def parse_test_results
      report_path = 'reports/cucumber_report.json'
      raise ValidationError, "Report not found: #{report_path}" unless File.exist?(report_path)

      report = JSON.parse(File.read(report_path))
      report.each { |feature| parse_feature(feature) }
    end

    def parse_feature(feature)
      return unless feature['elements']

      feature['elements'].each { |scenario| parse_scenario(scenario) }
    end

    def parse_scenario(scenario)
      return unless scenario['steps']

      scenario['steps'].each { |step| parse_step(step) }
    end

    def parse_step(step)
      @total_steps += 1

      case step['result']['status']
      when 'passed' then @passed_steps << step
      when 'failed' then @failed_steps << build_failed_step_hash(step)
      when 'undefined' then @undefined_steps << build_undefined_step_hash(step)
      end
    end

    def build_failed_step_hash(step)
      { step: step['name'], error: step['result']['error_message'], location: step['match']['location'].to_s }
    end

    def build_undefined_step_hash(step)
      { step: step['name'], keyword: step['keyword'] }
    end

    def generate_validation_result
      {
        valid: valid?,
        message: validation_message,
        stats: {
          total: @total_steps,
          passed: @passed_steps.length,
          failed: @failed_steps.length,
          undefined: @undefined_steps.length
        },
        failures: @failed_steps,
        undefined: @undefined_steps
      }
    end
  end
end
