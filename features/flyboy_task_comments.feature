@javascript
Feature: Manage task comments
  Background:
    Given an authenticated user

  Scenario: Create a comment
    Given an existing task
    When I go to the tasks section
    When I consult this task
    And I create a new task comment
    Then I am on this task
    And the task comment is created
