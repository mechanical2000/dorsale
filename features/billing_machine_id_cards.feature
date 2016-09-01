@javascript
Feature: IdCards

  Scenario: New idcard
    Given an authenticated user
    And the user goes on the new idcard page
    When he fills the idcard's information
    And creates a new idcard
    Then he is redirected on the idcards page
    And the idcard is added to the idcard list

  Scenario: Update idcard
    Given an authenticated user
    And an existing idcard
    When the user edits the idcard
    Then the current idcard's label should be pre-filled
    When he validates the new idcard
    Then he is redirected on the idcards page
    And the idcard's label is updated
