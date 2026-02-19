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

### pre-commit
Runs before each commit:
- RSpec unit tests (10 examples)
- Cucumber BDD scenarios (41 scenarios, 241 steps)
- RuboCop linting

**Skip with:**
```bash
SKIP_HOOKS=1 git commit -m "message"
# or
git commit --no-verify -m "message"
```

### pre-push
Runs before pushing to remote:
- RSpec test suite (with --fail-fast)
- Cucumber test suite (with --fail-fast)
- Test coverage analysis (warns if below 80%)

**Skip with:**
```bash
SKIP_HOOKS=1 git push
# or
git push --no-verify
```

**Note:** Use skip options sparingly and only for emergency hotfixes!
