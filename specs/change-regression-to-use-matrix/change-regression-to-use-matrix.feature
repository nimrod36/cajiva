Feature: Change regression to use matrix for calculations  
  As a data scientist  
  I want the regression calculations to use only matrix operations  
  So that the calculations are more efficient and consistent  

  Background:  
    Given a dataset with numeric features and target values  
    And a regression model implementation that supports matrix operations  

  Scenario: Perform linear regression using matrix operations  
    Given a dataset with features [1, 2, 3] and target values [2, 4, 6]  
    When I perform linear regression using matrix calculations  
    Then the model coefficients should match the expected values [0, 2]  

  Scenario: Handle empty dataset gracefully  
    Given an empty dataset with no features or target values  
    When I attempt to perform regression using matrix calculations  
    Then an error should be raised saying "Dataset cannot be empty"  

  Scenario: Handle non-numeric data in the dataset  
    Given a dataset with features [1, "a", 3] and target values [2, 4, 6]  
    When I attempt to perform regression using matrix calculations  
    Then an error should be raised saying "Non-numeric data detected in the dataset"  

  Scenario: Perform regression with multiple features  
    Given a dataset with features [[1, 2], [2, 3], [3, 4]] and target values [3, 5, 7]  
    When I perform linear regression using matrix calculations  
    Then the model coefficients should match the expected values [1, 1]  

  Scenario: Handle dataset with mismatched feature and target dimensions  
    Given a dataset with features [[1, 2], [2, 3]] and target values [3, 5, 7]  
    When I attempt to perform regression using matrix calculations  
    Then an error should be raised saying "Feature and target dimensions do not match"  

  Scenario: Validate zero variance in features  
    Given a dataset with features [1, 1, 1] and target values [2, 4, 6]  
    When I attempt to perform regression using matrix calculations  
    Then an error should be raised saying "Features have zero variance"  

  Scenario Outline: Regression with valid datasets  
    Given a dataset with features <features> and target values <targets>  
    When I perform linear regression using matrix calculations  
    Then the model coefficients should match the expected values <coefficients>  

    Examples:  
      | features              | targets     | coefficients |  
      | [[1, 2], [3, 4]]      | [5, 9]      | [1, 2]       |  
      | [[1, 0], [0, 1]]      | [3, 4]      | [3, 4]       |  
      | [[2, 3], [4, 5]]      | [8, 14]     | [2, 2]       |  

  Scenario: Handle singular matrix during regression  
    Given a dataset with features [[1, 2], [2, 4], [3, 6]] and target values [3, 6, 9]  
    When I attempt to perform regression using matrix calculations  
    Then an error should be raised saying "Singular matrix detected, cannot perform calculation"  

  Scenario: Test performance for large datasets  
    Given a dataset with 1,000,000 rows and 10 features  
    When I perform linear regression using matrix calculations  
    Then the computation should complete within an acceptable time limit  

  Scenario: Verify regression results with high precision  
    Given a dataset with features [[1.1, 2.2], [3.3, 4.4], [5.5, 6.6]] and target values [3.3, 7.7, 12.1]  
    When I perform linear regression using matrix calculations  
    Then the model coefficients should match the expected values with a tolerance of 0.0001  

  Scenario: Handle large numerical values in dataset  
    Given a dataset with features [[1e6, 2e6], [3e6, 4e6]] and target values [5e6, 9e6]  
    When I perform linear regression using matrix calculations  
    Then the model coefficients should match the expected values [1, 2]  

  Scenario: Validate output for standardized input data  
    Given a dataset with standardized features [[-1, 0], [0, 1], [1, 2]] and target values [0, 1, 2]  
    When I perform linear regression using matrix calculations  
    Then the model coefficients should match the expected values [1, 1]