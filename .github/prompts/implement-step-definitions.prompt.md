# Cucumber Step Snippet Generator

Generate idiomatic step definitions from undefined Gherkin steps.

## Instructions

1. **Detect Language** - Check project indicators (Gemfile→Ruby, package.json→TS/JS, pom.xml→Java, requirements.txt→Python, .csproj→C#, build.gradle.kts→Kotlin)
2. **Extract Steps** - Parse undefined steps from feature file
3. **Generate Snippets** - Use language-specific template below

## Language Templates

### Ruby
```ruby
# frozen_string_literal: true
require 'rspec/expectations'

Given('step text') { pending }
When('step text') { pending }
Then('step text') { expect(@result).to be_truthy }
```
- Path: `specs/<feature>/step_definitions/<feature>_steps.rb`
- State: instance variables (`@var`)

### TypeScript/JavaScript
```typescript
import { Given, When, Then } from '@cucumber/cucumber';
Given('step text', () => { throw new Error('Not implemented'); });
```
- Path: `features/step_definitions/<feature>.steps.ts`

### Java
```java
@Given("step text")
public void step() { throw new PendingException(); }
```
- Path: `src/test/java/.../stepdefs/<Feature>Steps.java`

### Python
```python
@given('step text')
def step(context): raise NotImplementedError()
```
- Path: `features/steps/<feature>_steps.py`

### C#
```csharp
[Given(@"step text")]
public void Step() { throw new PendingStepException(); }
```
- Path: `Features/StepDefinitions/<Feature>Steps.cs`

### Kotlin
```kotlin
Given("step text") { throw PendingException() }
```
- Path: `src/test/kotlin/.../stepdefs/<Feature>Steps.kt`

## Output Format

```markdown
### 🎯 Language: <detected>
### 📝 Steps: <list undefined steps>
### ✅ File: `<path>`
```<language>
<complete snippet>
```
```

## Checklist
- ✅ Correct imports/annotations
- ✅ Proper assertion library
- ✅ Pending markers for incomplete steps
- ✅ Declarative style (behavior, not implementation)
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