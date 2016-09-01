@javascript
Feature: Categories

  Scenario: New category
    Given an authenticated user
    And the user goes on the new category page
    When he fills the category's information
    And creates a new category
    Then he is redirected on the activities page
    And the category is added to the category list

  Scenario: Update category
    Given an authenticated user
    And an existing category
    When the user edits the category
    Then the current category's label should be pre-filled
    When he validates the new category
    Then he is redirected on the categories page
    And the category's label is updated
