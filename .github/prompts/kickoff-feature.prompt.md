---
name: kickoff-feature
description: Initiates the feature development lifecycle by analyzing requirements and generating test plans
---

# Kickoff Feature

You are orchestrating the feature development lifecycle. This prompt chains two critical preparatory steps:

## Workflow

1. **First**: Apply the `/create-test-plan` prompt to generate comprehensive BDD test scenarios
2. **Output**: A complete Gherkin feature file with scenarios covering:
   - Happy path behaviors
   - Edge cases and error handling
   - Data validation scenarios
   - API/integration scenarios
   - Three Amigos perspectives (Product, Dev, QA)

## Execution

Read the issue description and:
1. Extract the feature/bug/enhancement requirements
2. Apply the create-test-plan methodology
3. Generate declarative, anti-fragile Gherkin scenarios
4. Format output as a complete test plan

## Output Format

```gherkin
Feature: [Feature Name]
  As a [role]
  I want [capability]
  So that [business value]

  Background:
    Given [common preconditions]

  Scenario: [Happy path scenario name]
    Given [initial state]
    When [action or event]
    Then [expected outcome]
    And [additional expectations]

  Scenario: [Edge case scenario name]
    Given [edge condition setup]
    When [action under edge conditions]
    Then [expected behavior]

  Scenario Outline: [Data-driven scenario name]
    Given [setup with <parameter>]
    When [action with <parameter>]
    Then [expected <result>]
    
    Examples:
      | parameter | result |
      | value1    | result1 |
      | value2    | result2 |
```

## Guiding Principles

- **Declarative over Imperative**: Focus on behavior, not UI mechanics
- **Anti-Fragile**: Tests survive refactoring and implementation changes
- **Living Documentation**: Scenarios serve as executable specifications
- **Comprehensive Coverage**: Include happy paths, edge cases, and error conditions
- **Business Value**: Each scenario ties back to user needs or business rules

## References

- Based on: "Specification by Example" (Gojko Adzic)
- Methodology: "The Cucumber Book" (Wynne & Hellesøy)
- Style: "Writing Great Specifications" (Kamil Nicieja)

---

**Note**: This prompt halts after test plan generation. It does NOT implement code or create files. The output serves as the "immutable anchor" for subsequent agentic development work.
