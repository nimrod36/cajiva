# Cajiva - Linear Regression Analysis Tool

A Ruby-based data analysis application that performs linear regression on temperature data with an interactive web visualization. Features automated testing, CI/CD pipelines, dual regression methods, and AI-powered feature development automation.

## Features

### Core Functionality
- **Linear Regression**: Implements least-squares regression with both matrix projection and traditional formula methods
- **JSON Data Source**: Temperature data for Tel Aviv (June 2024) stored in JSON format
- **Web UI**: Interactive Chart.js visualization showing temperature trends and regression line
- **API**: RESTful endpoint serving regression data

### Code Quality & DevOps
- **Git Hooks**: Automatic test and linting on commit and push
- **GitHub Actions CI**: Continuous integration across multiple Ruby versions
- **Test Suite**: Comprehensive RSpec tests with 10 examples
- **Code Quality**: RuboCop linting with custom configuration

### AI-Powered Development Automation ✨
- **🤖 Auto Test Plan Generation**: New issues automatically get comprehensive BDD test plans via Copilot
- **🔗 Linear Integration**: Sync Linear issues to GitHub with automatic feature kickoff
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

## Hosting (Render or Railway)

This project includes a Procfile and Rack config so it can be deployed to common Ruby hosts.

### Render (recommended)

1. Create a new **Web Service** from your GitHub repo.
2. Set **Build Command**: `bundle install`
3. Set **Start Command**: `bundle exec rackup -p $PORT -o 0.0.0.0`
4. Deploy. Render will provide a public URL.

### Railway

1. Create a new service from GitHub.
2. Use **Start Command**: `bundle exec rackup -p $PORT -o 0.0.0.0`
3. Deploy and use the generated URL.

### Running Tests

```bash
bundle exec rspec
```

### Running Linter

```bash
bundle exec rubocop
```

## Project Structure

```
cajiva/
├── app.rb                    # Sinatra web server
├── main.rb                   # CLI application
├── lib/
│   ├── linear_regression.rb  # Regression algorithms (matrix & formula)
│   ├── json_data_fetcher.rb  # Data loading from JSON
│   ├── database_connection.rb # MySQL support (optional)
│   └── version.rb            # Version info
├── data/
│   └── temperature_data.json # Sample temperature dataset
├── public/
│   └── index.html           # Web UI with Chart.js
└── spec/                    # RSpec tests
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

The project includes two automatic hooks:

- **pre-commit**: Runs tests and linting before each commit
- **pre-push**: Runs full test suite before pushing to remote

These ensure code quality before it reaches the repository.

## CI/CD

GitHub Actions workflows automatically run on every push:
- Ruby 2.7, 3.0, 3.1 compatibility testing
- RSpec test suite execution
- RuboCop linting
- BDD test plan generation on new issues
- Linear issue synchronization (via webhook)

## AI-Powered Feature Development

### Automatic Test Plan Generation

When you create a new issue, GitHub Copilot automatically generates a comprehensive BDD test plan:

```bash
# Create an issue (or use Linear webhook)
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

### Linear Integration

Connect Linear issues to GitHub for automated feature kickoff:

1. **Configure Linear webhook** to send issues to GitHub repository dispatch endpoint
2. **Issues sync automatically** with Linear context (priority, team, assignee)
3. **Target repo routing** via issue body (`repo: owner/name`) or labels (`repo:owner/name`)
4. **Copilot generates test plan** on issue creation

See [.github/workflows/linear-webhook-handler.yml](.github/workflows/linear-webhook-handler.yml) for implementation details.

### Workflow Files

- [kickoff-feature-automation.yml](.github/workflows/kickoff-feature-automation.yml) - Auto-generates test plans on issue creation
- [linear-webhook-handler.yml](.github/workflows/linear-webhook-handler.yml) - Syncs Linear issues to GitHub
- [generate-test-plan.yml](.github/workflows/generate-test-plan.yml) - Legacy test plan generator (kept for compatibility)

GitHub Actions automatically runs tests on:
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

Tests run across Ruby versions 2.7, 3.0, and 3.1.
