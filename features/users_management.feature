@javascript
Feature: Manage users
  As an user
  I can manage users
  In order to provide them an access

  Background:
    Given an existing user
    When he goes to the users section

  Scenario: Create a User
    And he creates a new user
    Then the user is visible in the user list

  Scenario: Update a User
    And he click on update user button
    And he update the user
    Then the user's new informations are visible in the users list