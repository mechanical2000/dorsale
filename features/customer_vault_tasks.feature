@javascript
Feature: Create tasks on people
  Background:
    Given an existing user

  Scenario: Add a task to a corporation
    Given an existing corporation
    When I go on this corporation
    And I go on the tasks section
    And I create a task on this person
    Then the person task is created
    When I go on this corporation
    And I go on the tasks section
    Then the task appear
    When I go on the general tasks page
    Then the task appear

  Scenario: Add a task to an individual
    Given an existing individual
    When I go on this individual
    And I go on the tasks section
    And I create a task on this person
    Then the person task is created
    When I go on this individual
    And I go on the tasks section
    Then the task appear
    When I go on the general tasks page
    Then the task appear

  Scenario: Add a task to an individual
    Given an existing individual
    When I go on this individual
    And I go on the tasks section
    And I filter tasks
    Then I an redirected on the tasks tab
