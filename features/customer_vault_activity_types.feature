@javascript
Feature: People Activity types

  Scenario: New activity type
    Given an authenticated user
    And the user goes on the new activity type page
    When he fills the activity type's information
    And creates a new activity type
    Then he is redirected on the activity types page
    And the activity type is added to the activity types list

  Scenario: Update activity type
    Given an authenticated user
    And an existing activity type
    When I edit the activity type
    Then the current activity type's name should be pre-filled
    When he validates the new activity type
    Then he is redirected on the activity types page
    And the activity type's label is updated
