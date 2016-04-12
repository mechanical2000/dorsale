@javascript
Feature: People search
  Background:
    Given an authenticated user
    Given existing individuals
    And existing corporations
    When he go to the people list

  Scenario: Search individual by first name
    When he search an individual by first name
    Then this individual appear in search results
    And other individuals do not appear in search results

  Scenario: Search individual by last name
    When he search an individual by last name
    Then this individual appear in search results
    And other individuals do not appear in search results

  Scenario: Search corporation by name
    When he search a corporation by name
    Then this corporation appear in search results
    And other corporations do not appear in search results
