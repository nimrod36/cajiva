# Cajiva - Linear Regression Analysis Tool

A Ruby-based data analysis application that performs linear regression on temperature data with an interactive web visualization. Features automated testing, CI/CD pipelines, dual regression methods, and AI-powered feature development automation.

## Features

### Core Functionality
- **Linear Regression**: Implements least-squares regression with both matrix projection and traditional formula methods
- **JSON Data Source**: Temperature data for Tel Aviv (June 2024) stored in JSON format
- **Web UI**: Interactive Chart.js visualization showing temperature trends and regression line
- **API**: RESTful endpoint serving regression data

### Code Quality & DevOps
- **Git Hooks**: Automated test execution on commit/push
- **GitHub Actions CI**: Multi-version Ruby testing (2.7, 3.0, 3.1)
- **Test Coverage**: RSpec unit tests + Cucumber BDD scenarios
- **PR Validation**: Automated validation ensuring all tests pass before merge
- **Repository Maintenance**: Clean, organized structure following best practices

### AI-Powered Development Automation ✨
- **🤖 Auto Test Plan Generation**: New issues automatically get comprehensive BDD test plans via Copilot
- **📝 Copilot Prompts**: Custom prompts for test coverage and feature development
- **🎯 Workflow Automation**: `/kickoff-feature` prompt generates Gherkin scenarios on issue creation

## Setup

### Prerequisites
- Ruby 2.7+
- Bundler

### Installation

```bash
bundle install
```

### Running the Web Application

Start the Sinatra server:

```bash
ruby app.rb
```

Then open your browser to http://localhost:4567

The web UI displays:
- Interactive scatter plot of temperature data
- Overlaid linear regression line
- Statistics: slope, R², equation, and data point count

### Running the CLI

Run the command-line analysis:

```bash
ruby main.rb
```

### Running Tests

Run RSpec unit tests:

```bash
bundle exec rspec
```

Run Cucumber BDD scenarios:

```bash
bundle exec cucumber
```

Run tests for a specific feature:

```bash
bundle exec cucumber specs/repository-maintenance/
```

## Project Structure

```
cajiva/
├── app.rb                    # Sinatra web server
├── main.rb                   # CLI application
├── lib/
│   ├── linear_regression.rb  # Regression algorithms (matrix & formula)
│   ├── json_data_fetcher.rb  # JSON data loading
│   ├── data_fetcher.rb       # Data fetching interface
│   ├── pr_validator.rb       # PR validation with test coverage checks
│   ├── database_connection.rb # MySQL support (optional)
│   └── version.rb            # Version info
├── data/
│   └── temperature_data.json # Temperature dataset (Tel Aviv, June 2024)
├── public/
│   └── index.html           # Web UI with Chart.js visualization
├── spec/                    # RSpec unit tests
├── specs/                   # Cucumber BDD feature tests
│   ├── git-hooks-installer/
│   ├── test-pr-merge/
│   └── repository-maintenance/
└── hooks/                   # Git hooks for automated quality checks
    ├── pre-commit           # Test & lint before commit
    ├── pre-push             # Full test suite before push
    └── README.md            # Hook documentation
```

## Linear Regression Methods

The application supports two calculation methods:

### 1. Matrix Projection (default)
Uses the normal equation: **β = (X'X)^(-1)X'y**

```ruby
model = Cajiva::LinearRegression.new(x, y)
```

### 2. Traditional Formula
Faster computation using direct formulas:

```ruby
model = Cajiva::LinearRegression.new(x, y, method: :formula)
```

Both methods produce identical results. The formula method is recommended for large datasets due to O(n) complexity vs O(n²-n³) for matrix operations.

## API Endpoints

### GET /api/data

Returns JSON with temperature data and regression analysis:

```json
{
  "actual": [{"x": 1, "y": 28.5}, ...],
  "regression": [{"x": 1, "y": 30.17}, ...],
  "equation": "y = 0.2008x + 29.9736",
  "r_squared": 0.8152,
  "slope": 0.2008,
  "intercept": 29.9736
}
```

## Git Hooks

The project includes automated quality checks via Git hooks:

### Pre-Commit Hook
Runs before each commit to ensure code quality:
- Executes RSpec unit tests
- Runs Cucumber BDD scenarios

### Pre-Push Hook
Runs before pushing to remote to prevent broken builds:
- Full RSpec test suite execution
- Full Cucumber BDD scenarios
- All tests must pass

### Installation

Install hooks using the provided script:

```bash
./install-hooks.sh
```

Skip hooks when needed:

```bash
SKIP_HOOKS=1 git commit -m "message"
```

## CI/CD

GitHub Actions workflows automatically run:
- Ruby 2.7, 3.0, 3.1 compatibility testing on push to `main`
- RSpec test suite execution
- Cucumber BDD scenarios
- BDD test plan generation on new issues

## AI-Powered Feature Development

### Automatic Test Plan Generation

When you create a new issue, GitHub Copilot automatically generates a comprehensive BDD test plan:

```bash
# Create an issue
# The kickoff-feature-automation workflow triggers automatically
# Within 30 seconds, a comment appears with:
# - Gherkin scenarios
# - Test coverage analysis
# - Implementation guidance
```

### Copilot Prompts

The repository includes custom Copilot prompts:

- **`@copilot /kickoff-feature`** ([.github/prompts/kickoff-feature.prompt.md](.github/prompts/kickoff-feature.prompt.md))
  - Orchestrates feature development lifecycle
  - Generates comprehensive test plans automatically
  
- **`@copilot /create-test-plan`** ([.github/prompts/create-test-plan.prompt.md](.github/prompts/create-test-plan.prompt.md))
  - Creates BDD test plans following Specification by Example
  - Follows declarative, anti-fragile design principles
  
- **`@copilot /add-test-coverage`** ([.github/prompts/add-test-coverage.prompt.md](.github/prompts/add-test-coverage.prompt.md))
  - Extends existing feature files with additional scenarios
  - Implements step definitions in Ruby/Cucumber

### Workflow Files

- [kickoff-feature-automation.yml](.github/workflows/kickoff-feature-automation.yml) - Auto-generates test plans on issue creation
- [ci.yml](.github/workflows/ci.yml) - Continuous integration testing across Ruby versions

GitHub Actions automatically runs tests on:
- Push to `main`
- Pull requests to `main`

Tests run across Ruby versions 2.7, 3.0, and 3.1.

## Trigger CI

GitHub Actions CI is automatically triggered by:

1. **Push to main branch**: Any commit pushed directly to `main` triggers the full test suite
2. **Pull Request to main**: Opening or updating a PR targeting `main` runs all tests
   - RSpec unit tests across Ruby 2.7, 3.0, and 3.1
   - Cucumber BDD scenarios with strict undefined step checking
   - Tests must pass before merge is allowed
