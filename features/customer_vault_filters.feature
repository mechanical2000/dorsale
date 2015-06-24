@javascript
Feature: Filter people
  Scenario: Filter by tags
    Given an existing corporation with tags hello and world
    And an other existing corporation with tags hello and goodbye
    And an other existing corporation with tag yeah
    When I go the to people list
    And I filter with tag hello
    Then only first and second corporation appear
    When I add the second tag world
    Then only the first corporation appear
