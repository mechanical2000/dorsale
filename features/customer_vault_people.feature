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
