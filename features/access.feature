@javascript
Feature: Users
  As a user
  I want to access the application
  In order to use it

  Scenario: Active user can login
    Given an active user
    When he try to access to the application
    Then a message signal that's the user is logged

  Scenario: Inactive user cant login
    Given an inactive user
    When he try to access to the application
    Then an error message signal that's account is inactive


