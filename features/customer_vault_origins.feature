@javascript
Feature: People Origins

  Scenario: New origin
    Given an authenticated user
    And the user goes on the new origin page
    When he fills the origin's information
    And creates a new origin
    Then he is redirected on the origins page
    And the origin is added to the origin list

  Scenario: Update origin
    Given an authenticated user
    And an existing origin
    When I edit the origin
    Then the current origin's name should be pre-filled
    When he validates the new origin
    Then he is redirected on the origins page
    And the origin's label is updated
