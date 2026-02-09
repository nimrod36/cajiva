# Git Hooks

This directory contains git hooks for the project.

## Installation

To install these hooks, run:

```bash
chmod +x hooks/*
cp hooks/pre-commit .git/hooks/
cp hooks/pre-push .git/hooks/
```

## Hooks

- **pre-commit**: Runs RSpec tests, Cucumber tests, and RuboCop linting before each commit
- **pre-push**: Runs full RSpec and Cucumber test suites before pushing to remote
