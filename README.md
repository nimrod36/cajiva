# Cajiva - Linear Regression Analysis Tool

A Ruby-based data analysis application that performs linear regression on temperature data with an interactive web visualization. Features automated testing, CI/CD pipelines, and dual regression methods (matrix projection and formula-based).

## Features

### Core Functionality
- **Linear Regression**: Implements least-squares regression with both matrix projection and traditional formula methods
- **JSON Data Source**: Temperature data for Tel Aviv (June 2024) stored in JSON format
- **Web UI**: Interactive Chart.js visualization showing temperature trends and regression line
  - **Add Data Points**: Users can add custom temperature readings through the UI
  - **Recalculate Regression**: Dynamically recalculate the regression line with new data points
  - **Real-time Updates**: Chart updates immediately when data is added
- **API**: RESTful endpoints serving regression data
  - GET `/api/data`: Returns initial temperature data with regression
  - POST `/api/calculate`: Accepts custom data points and returns new regression analysis

### Code Quality & DevOps
- **Git Hooks**: Automatic test and linting on commit and push
- **GitHub Actions CI**: Continuous integration across multiple Ruby versions
- **Test Suite**: Comprehensive RSpec tests with 15 examples
- **Code Quality**: RuboCop linting with custom configuration

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
- **Input form** to add new data points (day and temperature)
- **Add Point button** to add custom temperature readings to the chart
- **Recalculate Regression Line button** to recompute the regression with all data points

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

### POST /api/calculate

Accepts custom data points and returns new regression analysis:

**Request:**
```json
{
  "data": [
    {"x": 1, "y": 28.5},
    {"x": 2, "y": 29.1},
    {"x": 3, "y": 29.8}
  ]
}
```

**Response:**
```json
{
  "actual": [{"x": 1, "y": 28.5}, {"x": 2, "y": 29.1}, {"x": 3, "y": 29.8}],
  "regression": [{"x": 1, "y": 28.5}, {"x": 2, "y": 29.1}, {"x": 3, "y": 29.8}],
  "equation": "y = 0.65x + 27.85",
  "r_squared": 1.0,
  "slope": 0.65,
  "intercept": 27.85
}
```

## Git Hooks

The project includes two automatic hooks:

- **pre-commit**: Runs tests and linting before each commit
- **pre-push**: Runs full test suite before pushing to remote

These ensure code quality before it reaches the repository.

## CI/CD

GitHub Actions automatically runs tests on:
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

Tests run across Ruby versions 2.7, 3.0, and 3.1.
