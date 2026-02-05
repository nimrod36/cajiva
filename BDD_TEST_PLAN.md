# Cajiva BDD Test Plan

This document describes the Behavior-Driven Development (BDD) test plan implemented for the Cajiva linear regression analysis application.

## Overview

The test plan follows the **Specification by Example** approach and implements comprehensive Gherkin scenarios covering:

- **Regression Model Calculation**: Core mathematical operations with both matrix and formula methods
- **Prediction & Extrapolation**: Temperature predictions within and beyond training data
- **Web API Service**: RESTful endpoint testing and data precision validation
- **Error Handling**: Edge cases, insufficient data, and failure scenarios

## Test Structure

```
cajiva/
├── specs/
│   ├── linear-regression-temperature-analysis/
│   │   ├── linear-regression-temperature-analysis.feature
│   │   └── step_definitions/
│   │       ├── regression_steps.rb
│   │       └── api_steps.rb
│   └── support/
│       └── env.rb
├── cucumber.yml
└── Gemfile (updated with cucumber dependencies)
```

## Running the Tests

### Prerequisites

```bash
bundle install
```

### Run All BDD Scenarios

```bash
bundle exec cucumber specs/linear-regression-temperature-analysis/linear-regression-temperature-analysis.feature
```

### Run with Different Formats

```bash
# Summary format
bundle exec cucumber specs/linear-regression-temperature-analysis/linear-regression-temperature-analysis.feature --format summary

# Progress format
bundle exec cucumber specs/linear-regression-temperature-analysis/linear-regression-temperature-analysis.feature --format progress

# HTML report
bundle exec cucumber specs/linear-regression-temperature-analysis/linear-regression-temperature-analysis.feature --format html --out report.html
```

### Run Specific Scenarios

```bash
# Run a specific scenario by line number
bundle exec cucumber specs/linear-regression-temperature-analysis/linear-regression-temperature-analysis.feature:12

# Run scenarios with a specific tag (if tags are added)
bundle exec cucumber --tags @api
```

## Test Coverage

### ✅ Passing Scenarios (13)

1. **Calculate regression model with valid temperature data** - Validates basic model generation
2. **Generate correct regression equation format** - Ensures proper equation string formatting
3. **Both calculation methods produce identical results** - Verifies matrix and formula methods converge
4. **Support custom regression method selection** - Tests method parameter functionality
5. **Handle identically-valued y-data** - Edge case with zero variance
6. **Predict temperature for a day within data range** - In-range prediction validation
7. **Verify prediction at intercept point** - Validates prediction at x=0
8. **Extrapolate temperature beyond data range** - Out-of-range prediction behavior
9. **API returns complete regression analysis** - Full API response validation
10. **Ensure API response data points match expected precision** - Decimal rounding validation
11. **Handle insufficient data for regression** - Error handling with < 2 data points
12. **Regression produces correct R² for perfectly correlated data** - Perfect fit validation
13. **Handle singular matrix in matrix calculation** - Singular matrix graceful handling

### ⏳ Pending Scenarios (2)

1. **Web UI renders visualization from API data** - Requires browser/JavaScript testing (Capybara/Selenium)
2. **Handle JSON data source unavailability** - Requires file system mocking

## Test Philosophy

### Declarative Style

The test scenarios follow a **declarative** (behavior-focused) style rather than imperative (implementation-focused):

❌ **Imperative**: "When I click the calculate button and enter values 1 and 2..."  
✅ **Declarative**: "When the system calculates regression on valid data..."

This ensures tests remain stable as implementation details change.

### Coverage Strategy

The test plan employs the **Three Amigos** perspective:

- **Product**: Business rules and happy paths
- **Developer**: Technical boundaries and state requirements
- **Tester**: Edge cases, race conditions, failure modes

### Anti-Fragility

Tests act as "Living Documentation" and an **Immutable Anchor** for agentic development, ensuring:
- Business rules are clear and validated
- Edge cases are documented
- System behavior is predictable across refactors

## Dependencies

```ruby
gem 'cucumber', '~> 5.0'    # BDD testing framework
gem 'rack-test', '~> 1.1'   # API endpoint testing
gem 'rspec', '~> 3.0'       # Expectations/matchers
gem 'ffi', '~> 1.15.0'      # Native extensions (Ruby 2.6 compatibility)
```

## Integration with CI/CD

The Cucumber tests can be integrated into existing CI/CD pipelines:

```yaml
# Example GitHub Actions step
- name: Run BDD Tests
  run: bundle exec cucumber specs/
```

## Future Enhancements

1. **Browser Testing**: Implement Capybara for full web UI validation
2. **File System Mocking**: Use tools like `FakeFS` for comprehensive error scenario testing
3. **Performance Tests**: Add scenarios for regression calculation performance benchmarks
4. **Data Validation**: Expand scenarios for various data distributions and outlier handling
5. **Tagging**: Add tags (@smoke, @integration, @api) for selective test execution

## Maintenance

- Keep scenarios declarative and behavior-focused
- Update step definitions when business rules change
- Maintain "Given-When-Then" structure
- Avoid coupling tests to implementation details
- Use Scenario Outlines for data-driven variations only when necessary

## Related Files

- **Feature File**: [specs/linear-regression-temperature-analysis/linear-regression-temperature-analysis.feature](specs/linear-regression-temperature-analysis/linear-regression-temperature-analysis.feature)
- **Step Definitions**: [specs/linear-regression-temperature-analysis/step_definitions/](specs/linear-regression-temperature-analysis/step_definitions/)
- **Unit Tests**: [spec/cajiva_spec.rb](spec/cajiva_spec.rb) (existing RSpec tests)

## Contact

For questions about the test plan or to contribute scenarios, please consult the "Specification by Example" guidelines and maintain the declarative style.
