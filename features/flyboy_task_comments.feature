@javascript
Feature: Manage folder comments
  Background:
    Given an existing user

  Scenario: Create a comment
    Given an existing task
    When I go to the tasks section
    When I consult this task
    And I create a new task comment
    Then I am on this task
    And the task comment is created
