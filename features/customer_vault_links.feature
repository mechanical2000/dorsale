@javascript
Feature: Manage links
  As a user
  I want to edit links
  In order to identify the people responsible for corporations

  Background:
    Given an authenticated user

  Scenario: Add a new link on individual
    Given an existing corporation
    And an existing indidual
    When I navigate to the link section of the indidual details
    And I add a new link to the individual
    And I provide the link and the target corporation
    And I validate the link
    Then the new link is displayed

  Scenario: Edit a link on individual
    Given an existing link
    When I navigate to the link section of the indidual details
    And I edit the link
    And I change the title
    And I validate the link
    Then the edited link is displayed

  Scenario: Delete a link on individual
    Given an existing link
    When I navigate to the link section of the indidual details
    And I delete the link
    Then the targeted link is removed

  Scenario: Add a new link on corporation
    Given an existing corporation
    And an existing indidual
    When I navigate to the link section of the corporation details
    And I add a new link to the corporation
    And I provide the link and the target individual
    And I validate the link
    Then the new link is displayed

  Scenario: Edit a link on corporation
    Given an existing link
    When I navigate to the link section of the corporation details
    And I edit the link
    And I change the title
    And I validate the link
    Then the edited link is displayed

  Scenario: Delete a link on corporation
    Given an existing link
    When I navigate to the link section of the corporation details
    And I delete the link
    Then the targeted link is removed
