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

  Scenario: Increment task comment progress JS
    Given an existing task
    When I go to the tasks section
    And I consult this task
    And I fill "task_comment_progress" with "0"
    Then "task_comment_progress" has value "0"
    When I click on "+5"
    Then "task_comment_progress" has value "5"
