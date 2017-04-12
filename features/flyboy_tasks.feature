@javascript
Feature: Manage tasks
  Background:
    Given an authenticated user

  Scenario: Create a task
    When I go to the tasks section
    And I create a task
    Then the task is created
    And I go to the tasks section

  Scenario: Read a task
    Given an existing task
    When I go to the tasks section
    And I consult this task
    Then I see this task

  Scenario: Update a task
    Given an existing task
    When I go to the tasks section
    And I update this task
    Then I am on the updated task
    And the task is updated

  Scenario: Delete a task
    Given an existing task
    When I go to the tasks section
    And I delete this task
    Then I am on the tasks section
    And the task is deleted

  Scenario: Complete a task
    Given an existing task
    When I go to the tasks section
    And I complete this task
    Then I am on the tasks section
    And the task is completed

  Scenario: Snooze a task
    Given an existing snoozable task
    When I go to the tasks section
    And I snooze this task
    Then I am on the tasks section
    And the task is snoozed

  Scenario: Export tasks to XLSX
    Given 3 existing tasks
    When I go to the tasks section
    And I export to XLSX
    Then I download XLSX file

  Scenario: Filter tasks
    Given an existing done task
    And an existing undone task
    When I go to the tasks section
    And I filter tasks by done
    Then only done tasks appear
    When I filter tasks by undone
    Then only undone tasks appear
    When I reset filters
    Then all tasks appear

  Scenario: Search tasks
    Given an existing task named "Hello"
    And an existing task named "World"
    When I go to the tasks section
    And I search "Hello"
    Then only the "Hello" task appear

  Scenario: Tasks pagination
    Given 100 existing tasks
    When I go to the tasks section
    Then tasks are paginated

  Scenario: Term email with owner
    Given a task with an owner that's the term is today
    When the flyboy daily crons run
    Then the owner receive an email

  Scenario: Term email without owner
    Given a task without owner
    When the flyboy daily crons run
    Then no email is sent

  Scenario: Term email for closed task
    Given a closed task with an owner
    When the flyboy daily crons run
    Then no email is sent

  Scenario: Task term JS
    When I go on the new task page
    Then I do not see "#task_term_custom" element
    When I select "Aujourd'hui"
    Then I do not see "#task_term_custom" element
    When I submit
    Then selected task term is "Aujourd'hui"
    Then I do not see "#task_term_custom" element
    When I select "Choisir une date"
    Then I see "#task_term_custom" element
    And I fill "task_term_custom" with "15/06/2016"
    And I submit
    Then selected task term is "Choisir une date"
    And I see "#task_term_custom" element
    And "task_term_custom" has value "15/06/2016"

  Scenario: Task term JS
    When I go on the new task page
    Then I do not see "#task_reminder_duration" element
    Then I do not see "#task_reminder_unit" element
    Then I do not see "#task_reminder_date" element
    When I select "Durée"
    Then I see "#task_reminder_duration" element
    Then I see "#task_reminder_unit" element
    Then I do not see "#task_reminder_date" element
    When I select "Date"
    Then I do not see "#task_reminder_duration" element
    Then I do not see "#task_reminder_unit" element
    Then I see "#task_reminder_date" element
    When I select "Aucun"
    Then I do not see "#task_reminder_duration" element
    Then I do not see "#task_reminder_unit" element
    Then I do not see "#task_reminder_date" element
