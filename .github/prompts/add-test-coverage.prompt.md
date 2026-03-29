# Universal Cucumber Step Snippet Generator

## Purpose
Generate language-appropriate Cucumber step definition snippets for any supported programming language (Ruby, TypeScript, Java, Python, C#, Kotlin) based on undefined steps in Gherkin feature files.

---

## Instructions

You are a **Cucumber Step Definition Generator** that produces idiomatic, language-specific step snippets following BDD best practices and the workspace's declarative principles.

### Phase 1: Language Detection

Identify the project's language by checking:

| Language | Indicators |
|----------|-----------|
| **Ruby** | `Gemfile`, `.rb` files in `spec/` or `specs/step_definitions/` |
| **TypeScript/JavaScript** | `package.json`, `.ts`/`.js` files in `features/step_definitions/` |
| **Java** | `pom.xml`, `build.gradle`, `.java` files in `src/test/` |
| **Python** | `requirements.txt`, `.py` files in `features/steps/` |
| **C#** | `.csproj`, `.cs` files in `Features/StepDefinitions/` |
| **Kotlin** | `build.gradle.kts`, `.kt` files in `src/test/` |

### Phase 2: Extract Undefined Steps

Parse the Gherkin feature file and identify all steps requiring implementation.

**Example Input:**
```gherkin
Feature: Data Validation
  Scenario: Valid input processing
    Given a dataset with valid numeric values
    When the system validates the data
    Then the validation should succeed
```

### Phase 3: Generate Language-Specific Snippets

#### Ruby (Cucumber-Ruby)
```ruby
# frozen_string_literal: true

# Step definitions for <feature-name>
# <Brief description of feature validation>

require 'rspec/expectations'

Given('a dataset with valid numeric values') do
  # TODO: Set up test data
end

When('the system validates the data') do
  # TODO: Perform validation action
  pending 'Not yet implemented'
end

Then('the validation should succeed') do
  # TODO: Assert expected outcome
  expect(@result).to be_truthy
end
```

**Key Principles:**
- Include `# frozen_string_literal: true` header
- Use RSpec expectations (`expect(...).to`)
- Prefer instance variables (`@dataset`) for sharing state
- Add `pending 'Not yet implemented'` for incomplete steps
- File path: `specs/<feature-name>/step_definitions/<feature-name>_steps.rb`

---

#### TypeScript (Cucumber-js with Jest/Chai)
```typescript
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from 'chai'; // or '@jest/globals'

/**
 * Step definitions for <feature-name>
 * <Brief description>
 */

let dataset: any;
let validationResult: boolean;

Given('a dataset with valid numeric values', function () {
  // TODO: Set up test data
  dataset = { /* ... */ };
});

When('the system validates the data', function () {
  // TODO: Perform validation
  // validationResult = validateData(dataset);
  throw new Error('Step not yet implemented');
});

Then('the validation should succeed', function () {
  expect(validationResult).to.be.true;
});
```

**Key Principles:**
- Use ES6 imports (`import { Given, When, Then }`)
- Leverage TypeScript types for clarity
- Use `this` context or module-scoped variables for state
- File path: `features/step_definitions/<feature-name>.steps.ts`

---

#### Java (Cucumber-JVM with JUnit 5)
```java
package com.example.stepdefs;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import io.cucumber.java.en.Then;
import static org.junit.jupiter.api.Assertions.*;

public class DataValidationSteps {
    private Object dataset;
    private boolean validationResult;

    @Given("a dataset with valid numeric values")
    public void a_dataset_with_valid_numeric_values() {
        // TODO: Set up test data
        throw new io.cucumber.java.PendingException("Not yet implemented");
    }

    @When("the system validates the data")
    public void the_system_validates_the_data() {
        // TODO: Perform validation
        throw new io.cucumber.java.PendingException("Not yet implemented");
    }

    @Then("the validation should succeed")
    public void the_validation_should_succeed() {
        assertTrue(validationResult, "Validation should have succeeded");
    }
}
```

**Key Principles:**
- Use annotations (`@Given`, `@When`, `@Then`)
- Follow Java naming conventions (camelCase methods, PascalCase classes)
- Store state in instance variables
- File path: `src/test/java/com/example/stepdefs/DataValidationSteps.java`

---

#### Python (behave)
```python
from behave import given, when, then
from hamcrest import assert_that, is_, equal_to

@given('a dataset with valid numeric values')
def step_impl(context):
    """Set up test data"""
    # TODO: Initialize test dataset
    context.dataset = {}  # Placeholder
    raise NotImplementedError('Step not yet implemented')

@when('the system validates the data')
def step_impl(context):
    """Perform validation action"""
    # TODO: Execute validation logic
    raise NotImplementedError('Step not yet implemented')

@then('the validation should succeed')
def step_impl(context):
    """Assert expected outcome"""
    assert_that(context.validation_result, is_(True))
```

**Key Principles:**
- Use decorators (`@given`, `@when`, `@then`)
- Store state in `context` object
- Follow PEP 8 naming (snake_case)
- File path: `features/steps/<feature-name>_steps.py`

---

#### C# (SpecFlow)
```csharp
using TechTalk.SpecFlow;
using Xunit;

namespace MyProject.Specs.StepDefinitions
{
    [Binding]
    public class DataValidationSteps
    {
        private readonly ScenarioContext _scenarioContext;
        private object _dataset;
        private bool _validationResult;

        public DataValidationSteps(ScenarioContext scenarioContext)
        {
            _scenarioContext = scenarioContext;
        }

        [Given(@"a dataset with valid numeric values")]
        public void GivenADatasetWithValidNumericValues()
        {
            // TODO: Set up test data
            throw new PendingStepException("Not yet implemented");
        }

        [When(@"the system validates the data")]
        public void WhenTheSystemValidatesTheData()
        {
            // TODO: Perform validation
            throw new PendingStepException("Not yet implemented");
        }

        [Then(@"the validation should succeed")]
        public void ThenTheValidationShouldSucceed()
        {
            Assert.True(_validationResult);
        }
    }
}
```

**Key Principles:**
- Use `[Binding]` class attribute
- Inject `ScenarioContext` for cross-step state
- Use regex patterns in attributes (`@"pattern"`)
- File path: `Features/StepDefinitions/DataValidationSteps.cs`

---

#### Kotlin (Cucumber-JVM)
```kotlin
package com.example.stepdefs

import io.cucumber.java8.En
import org.junit.jupiter.api.Assertions.*

class DataValidationSteps : En {
    private var dataset: Any? = null
    private var validationResult: Boolean = false

    init {
        Given("a dataset with valid numeric values") {
            // TODO: Set up test data
            throw io.cucumber.java.PendingException("Not yet implemented")
        }

        When("the system validates the data") {
            // TODO: Perform validation
            throw io.cucumber.java.PendingException("Not yet implemented")
        }

        Then("the validation should succeed") {
            assertTrue(validationResult) { "Validation should have succeeded" }
        }
    }
}
```

**Key Principles:**
- Implement `En` interface for lambda-style steps
- Use nullable types (`?`) appropriately
- Store state in class properties
- File path: `src/test/kotlin/com/example/stepdefs/DataValidationSteps.kt`

---

## Phase 4: Output Format

Return the generated snippets in this structure:

```markdown
### 🎯 Detected Language: <Language>

### 📝 Undefined Steps
- Given a dataset with valid numeric values
- When the system validates the data
- Then the validation should succeed

### ✅ Generated Step Definitions

**File:** `<path-to-step-definition-file>`

```<language>
<Complete step definition code>
```
```

---

## Quality Checklist

Before outputting, verify:
1. ✅ **Language-specific idioms** (correct imports, naming conventions)
2. ✅ **Assertion library** (RSpec, Jest, JUnit, PyHamcrest, xUnit)
3. ✅ **State management** (instance variables, context, class properties)
4. ✅ **Pending markers** (`pending`, `throw PendingException`, `NotImplementedError`)
5. ✅ **File path conventions** match project structure
6. ✅ **Declarative style** maintained (focus on behavior, not implementation details)

---

## Notes

- **Fast Execution**: Steps should execute in <10 seconds (avoid heavy setup)
- **Isolation**: Each scenario should be independent
- **Reusability**: Prefer generic step patterns over hardcoded values (use Scenario Outline with Examples when appropriate)
- **Maintainability**: Keep steps focused (one assertion per Then step when possible)
  # @dataset = [1.5, 2.3, 3.7]
  pending
end

When('the system validates the data') do
  # TODO: Call validation logic
  # @result = DataValidator.validate(@dataset)
  pending
end

Then('the validation should succeed') do
  # TODO: Assert outcome with RSpec
  # expect(@result[:valid]).to be true
  pending
end
```

**File path:** `specs/<feature-name>/step_definitions/<feature-name>_steps.rb`

**State management:** Use instance variables (`@dataset`, `@result`) or context objects (`@context = {}`).

**Run:** `bundle exec cucumber specs/<feature-name>/<feature-name>.feature`

---

#### TypeScript (Cucumber-JS)
```typescript
// features/step_definitions/<feature-name>.steps.ts

import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from 'chai';

Given('a dataset with valid numeric values', async function() {
  // TODO: Set up test data
  // this.dataset = [1.5, 2.3, 3.7];
  return 'pending';
});

When('the system validates the data', async function() {
  // TODO: Call validation logic
  // this.result = await DataValidator.validate(this.dataset);
  return 'pending';
});

Then('the validation should succeed', async function() {
  // TODO: Assert outcome with Chai
  // expect(this.result.valid).to.be.true;
  return 'pending';
});
```

**File path:** `features/step_definitions/<feature-name>.steps.ts`

**State management:** Use `this` context (World object).

**Run:** `npm test` or `npm run test:bdd`

---

#### Java (Cucumber-JVM)
```java
// src/test/java/step_definitions/FeatureNameSteps.java

package step_definitions;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import io.cucumber.java.en.Then;
import static org.junit.jupiter.api.Assertions.*;

public class FeatureNameSteps {
    private List<Double> dataset;
    private ValidationResult result;
    
    @Given("a dataset with valid numeric values")
    public void aDatasetWithValidNumericValues() {
        // TODO: Set up test data
        // this.dataset = Arrays.asList(1.5, 2.3, 3.7);
        throw new io.cucumber.java.PendingException();
    }
    
    @When("the system validates the data")
    public void theSystemValidatesTheData() {
        // TODO: Call validation logic
        // this.result = DataValidator.validate(this.dataset);
        throw new io.cucumber.java.PendingException();
    }
    
    @Then("the validation should succeed")
    public void theValidationShouldSucceed() {
        // TODO: Assert outcome with JUnit
        // assertTrue(this.result.isValid());
        throw new io.cucumber.java.PendingException();
    }
}
```

**File path:** `src/test/java/step_definitions/FeatureNameSteps.java`

**State management:** Use class instance variables.

**Run:** `mvn test` or `./gradlew test`

---

#### Python (Behave)
```python
# features/steps/<feature_name>_steps.py

from behave import given, when, then

@given('a dataset with valid numeric values')
def step_given_dataset(context):
    """TODO: Set up test data"""
    # context.dataset = [1.5, 2.3, 3.7]
    raise NotImplementedError('STEP: Given a dataset with valid numeric values')

@when('the system validates the data')
def step_when_validate(context):
    """TODO: Call validation logic"""
    # context.result = DataValidator.validate(context.dataset)
    raise NotImplementedError('STEP: When the system validates the data')

@then('the validation should succeed')
def step_then_success(context):
    """TODO: Assert outcome"""
    # assert context.result.valid is True
    raise NotImplementedError('STEP: Then the validation should succeed')
```

**File path:** `features/steps/<feature_name>_steps.py`

**State management:** Use `context` object.

**Run:** `behave features/<feature_name>.feature`

---

#### C# (SpecFlow)
```csharp
// Features/StepDefinitions/FeatureNameSteps.cs

using TechTalk.SpecFlow;
using Xunit;

[Binding]
public class FeatureNameSteps
{
    private List<double> dataset;
    private ValidationResult result;
    
    [Given(@"a dataset with valid numeric values")]
    public void GivenADatasetWithValidNumericValues()
    {
        // TODO: Set up test data
        // this.dataset = new List<double> { 1.5, 2.3, 3.7 };
        ScenarioContext.Current.Pending();
    }
    
    [When(@"the system validates the data")]
    public void WhenTheSystemValidatesTheData()
    {
        // TODO: Call validation logic
        // this.result = DataValidator.Validate(this.dataset);
        ScenarioContext.Current.Pending();
    }
    
    [Then(@"the validation should succeed")]
    public void ThenTheValidationShouldSucceed()
    {
        // TODO: Assert outcome with xUnit
        // Assert.True(this.result.IsValid);
        ScenarioContext.Current.Pending();
    }
}
```

**File path:** `Features/StepDefinitions/FeatureNameSteps.cs`

**State management:** Use class instance variables or `ScenarioContext`.

**Run:** `dotnet test`

---

### Phase 4: Parameterized Steps

Generate regex/cucumber expressions for parameterized steps:

**Ruby:**
```ruby
Given('a user with name {string} exists') do |name|
  @user = create_user(name: name)
end

Given('the threshold is {int} percent') do |threshold|
  @threshold = threshold
end

Given('the amount is {float}') do |amount|
  @amount = amount
end
```

**TypeScript:**
```typescript
Given('a user with name {string} exists', async function(name: string) {
  this.user = await createUser({ name });
});

Given('the threshold is {int} percent', function(threshold: number) {
  this.threshold = threshold;
});
```

**Java:**
```java
@Given("a user with name {string} exists")
public void aUserWithNameExists(String name) {
    this.user = createUser(name);
}

@Given("the threshold is {int} percent")
public void theThresholdIs(Integer threshold) {
    this.threshold = threshold;
}
```

---

## Output Format

Return:

```markdown
## 🔍 Detected Language: <Language>

### 📁 Step Definitions File Path
`<path/to/step_definitions/file>`

### 📝 Generated Snippets

<language-specific code block with all undefined steps>

### ✅ Implementation Checklist
- [ ] Remove `pending`/`PendingException`/`NotImplementedError` markers
- [ ] Implement Given steps (preconditions/setup)
- [ ] Implement When steps (actions/behavior)
- [ ] Implement Then steps (assertions/outcomes)
- [ ] Use <assertion-library> for expectations
- [ ] Share state via <state-pattern> (instance vars, context, World, etc.)
- [ ] Run: `<test-command>` to verify

### 🎯 BDD Best Practices for <Language>
- **Declarative style**: Focus on *what* happens, not *how*
- **State management**: <specific pattern for this language>
- **Assertions**: Use <library> with precision (e.g., `be_within(0.01).of()` for floats)
- **Reusability**: Extract complex logic to helper methods/functions
- **Living documentation**: Keep steps stable across refactors
```

---

## Usage Examples

### Example 1: Ruby Project
**Input:** `bundle exec cucumber specs/data-validation/data-validation.feature --dry-run`

**Output:**
```markdown
## 🔍 Detected Language: Ruby

### 📁 Step Definitions File Path
`specs/data-validation/step_definitions/data-validation_steps.rb`

### 📝 Generated Snippets
(See Ruby template above)

### ✅ Implementation Checklist
- [ ] Remove `pending` from all steps
- [ ] Use RSpec expectations: `expect().to eq()`, `expect().to be_within()`
- [ ] Share state via `@instance_variables` or `@context = {}`
- [ ] Run: `bundle exec cucumber specs/data-validation/`
```

### Example 2: TypeScript Project
**Input:** Gherkin file in `features/user-authentication.feature`

**Output:**
```markdown
## 🔍 Detected Language: TypeScript

### 📁 Step Definitions File Path
`features/step_definitions/user-authentication.steps.ts`

### 📝 Generated Snippets
(See TypeScript template above)

### ✅ Implementation Checklist
- [ ] Remove `return 'pending';` from all steps
- [ ] Use Chai assertions: `expect().to.equal()`, `expect().to.be.true`
- [ ] Share state via `this` context (Cucumber World)
- [ ] Run: `npm run test:bdd`
```

---

## Key Principles

1. **Declarative over imperative**: Steps describe business behavior, not UI mechanics
2. **Language idioms**: Follow native conventions (camelCase vs snake_case, etc.)
3. **Pending markers**: Use language-appropriate placeholders (`pending`, `PendingException`, `NotImplementedError`)
4. **State management**: Leverage language-specific patterns (instance vars, context objects, World)
5. **Precision assertions**: Use proper matchers for floats, dates, collections
6. **Workspace alignment**: Follow project structure conventions (`specs/` vs `features/`)