@javascript
Feature: People
  Background:
    Given an authenticated user

  Scenario: Export people
    Given an existing individual
    Given an existing corporation
    When I go the to people list
    And I export people list
    Then the file is downloaded

  Scenario: Activity truncated comment
    Given an existing individual
    And a very long comment on this person
    When I go on the people activity
    Then I see the truncated comment
    When I click on show more
    Then I see the full comment

  Scenario: Activity not truncated comment
    Given an existing individual
    And a short comment on this person
    When I go on the people activity
    Then I see the full comment
