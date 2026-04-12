# frozen_string_literal: true

require 'json'
require 'open3'

module Cajiva
  # Validates that all test cases are implemented and passing for a pull request
  class PRValidator
    class ValidationError < StandardError; end

    DEFAULT_SPECS_PATH = 'specs/'
    REPORT_PATH = 'reports/cucumber_report.json'
    STEP_STATUS_PASSED = 'passed'
    STEP_STATUS_FAILED = 'failed'
    STEP_STATUS_UNDEFINED = 'undefined'

    attr_reader :undefined_steps, :failed_steps, :passed_steps, :total_steps

    def initialize(specs_path = DEFAULT_SPECS_PATH)
      @specs_path = specs_path
      reset_test_state
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

    def has_tests?
      @total_steps.positive?
    end

    def validation_message
      return 'All tests implemented and passing' if valid?

      build_failure_reasons.join('; ')
    end

    def valid?
      has_tests? && all_tests_implemented? && all_tests_passing?
    end

    private

    def reset_test_state
      @undefined_steps = []
      @failed_steps = []
      @passed_steps = []
      @total_steps = 0
      @exit_status = nil
      @test_output = ''
      @test_errors = ''
    end

    def build_failure_reasons
      reasons = []
      reasons << no_tests_message unless has_tests?
      reasons << undefined_steps_message unless all_tests_implemented?
      reasons << failing_tests_message unless all_tests_passing?
      reasons
    end

    def no_tests_message
      'Missing coverage: no test cases associated with the pull request'
    end

    def undefined_steps_message
      "Missing coverage: #{@undefined_steps.length} test step(s) not implemented"
    end

    def failing_tests_message
      "Failing tests: #{@failed_steps.length} test(s) not passing"
    end

    def run_cucumber_tests
      stdout, stderr, status = Open3.capture3(
        'bundle', 'exec', 'cucumber', @specs_path,
        '--strict-undefined',
        '--format', 'json',
        '--out', REPORT_PATH
      )

      @exit_status = status.exitstatus
      @test_output = stdout
      @test_errors = stderr
    end

    def parse_test_results
      raise ValidationError, "Report not found: #{REPORT_PATH}" unless File.exist?(REPORT_PATH)

      report = JSON.parse(File.read(REPORT_PATH))
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
      status = step['result']['status']

      case status
      when STEP_STATUS_PASSED then @passed_steps << step
      when STEP_STATUS_FAILED then @failed_steps << build_failed_step_hash(step)
      when STEP_STATUS_UNDEFINED then @undefined_steps << build_undefined_step_hash(step)
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
