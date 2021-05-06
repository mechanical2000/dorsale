@javascript
Feature: Expenses
  Background:
    Given an authenticated user
    And an existing expense category

  Scenario: Create expense
    When I go on the expenses page
    Then I see 0 expense
    When I create a new expense
    Then the expense is created
    And I am redirected on the expense page
    And I see 2 expense lines
    When I go on the expenses page
    Then I see 1 expense

  Scenario: Update expense
    Given an existing expense
    When I go on the expenses page
    Then I see 1 expense
    When I update the expense
    Then the expense is update
    And I am redirected on the expense page

  Scenario: Copy expense
    Given an existing expense
    When I go on the expense page
    When I copy the expense
    Then an expense copy is created
    And I am redirected on the expense page
