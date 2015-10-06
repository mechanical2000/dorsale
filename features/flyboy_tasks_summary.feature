Feature: Homepage
  As a user
  I want to see informations
  Classified on the homepage

  Background:
    Given an existing user
    Given an existing folder

  Scenario: Expired tasks
    Given an expired tasks
    When he go to the tasks summary page
    Then the task is classed as 'expired'

  Scenario: Todays tasks
    Given a task that expire today
    When he go to the tasks summary page
    Then the task is classed as 'Expire Today'

  Scenario: Tomorrow tasks
    Given a task that expire tommorow
    When he go to the tasks summary page
    Then the task is classed as 'Expire tommorow'
