# Cajiva - DevOps CI/CD Pipeline

A Ruby-based DevOps project demonstrating automated testing and quality checks through git hooks and CI/CD pipelines.

## Features

- **Git Hooks**: Automatic test and linting on commit and push
- **GitHub Actions CI**: Continuous integration across multiple Ruby versions
- **Test Suite**: RSpec-based testing framework
- **Code Quality**: RuboCop linting

## Setup

### Prerequisites
- Ruby 2.7+
- Bundler

### Installation

```bash
bundle install
chmod +x .git/hooks/pre-commit .git/hooks/pre-push
```

### Running Tests

```bash
bundle exec rspec
```

### Running Linter

```bash
bundle exec rubocop
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
