Feature: Regression calculation using matrices  
  As a data analyst  
  I want the regression calculation to use matrices  
  So that the calculation is more efficient and scalable  

  Background:  
    Given the system has a dataset with numeric features and a target variable  
    And the regression module is configured to use matrix-based calculations  

  Scenario: Calculate regression coefficients using matrix operations  
    Given a dataset with numeric features and a target variable  
    When the regression calculation is initiated  
    Then the system should compute the regression coefficients using matrix operations  

  Scenario: Handle invalid input with non-numeric values in the dataset  
    Given a dataset with non-numeric values in the features or target variable  
    When the regression calculation is initiated  
    Then the system should raise an error indicating invalid input  

  Scenario: Handle regression calculation for a dataset with a single feature  
    Given a dataset with a single numeric feature and a target variable  
    When the regression calculation is initiated  
    Then the system should compute the regression coefficients correctly  

  Scenario: Handle regression calculation for an empty dataset  
    Given an empty dataset  
    When the regression calculation is initiated  
    Then the system should raise an error indicating that the dataset is empty  

  Scenario: Validate the output of matrix-based regression calculation  
    Given a dataset with known regression coefficients  
    When the regression calculation is initiated  
    Then the computed coefficients should match the known coefficients  

  Scenario Outline: Perform regression calculation on datasets with varying sizes  
    Given a dataset with <number_of_features> features and <number_of_records> records  
    When the regression calculation is initiated  
    Then the system should compute the regression coefficients efficiently  

    Examples:  
      | number_of_features | number_of_records |  
      | 2                  | 100               |  
      | 5                  | 1000              |  
      | 10                 | 10000             |  

  Scenario: Check performance of matrix-based regression on large datasets  
    Given a dataset with 100 features and 1,000,000 records  
    When the regression calculation is initiated  
    Then the calculation should complete within the acceptable performance threshold  

  Scenario: Handle edge case with highly correlated features  
    Given a dataset with features that are highly correlated  
    When the regression calculation is initiated  
    Then the system should handle the collinearity and provide a meaningful result  

  Scenario: Handle missing values in the dataset  
    Given a dataset with missing values in the features or target variable  
    When the regression calculation is initiated  
    Then the system should raise an error indicating missing data  

  Scenario: Validate weights are updated using matrix multiplication  
    Given a dataset with numeric features and a target variable  
    When the regression calculation is initiated  
    Then the weight updates should be performed using matrix multiplication  

  Scenario: Handle numerical stability for large datasets  
    Given a dataset with very large numeric values in the features or target variable  
    When the regression calculation is initiated  
    Then the system should ensure numerical stability in the computation  

  Scenario: Verify compatibility with sparse matrix datasets  
    Given a sparse matrix dataset with numeric features and a target variable  
    When the regression calculation is initiated  
    Then the system should compute the regression coefficients correctly without errors  

  Scenario: Handle division by zero in matrix calculations  
    Given a dataset where one or more features have zero variance  
    When the regression calculation is initiated  
    Then the system should raise an error indicating division by zero in matrix calculations  

  Scenario: Support multiple regression models  
    Given a dataset with numeric features and a target variable  
    When the user selects a specific regression model (e.g., linear, ridge, lasso)  
    Then the system should compute the regression coefficients using the selected model  

  Scenario: Ensure consistent results across multiple runs  
    Given a dataset with numeric features and a target variable  
    When the regression calculation is run multiple times  
    Then the computed regression coefficients should be consistent across all runs