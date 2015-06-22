Feature: Id Cards Management
  As an administrator
  I want to create id cards
  In order to edit my entity informations

  @javascript
  Scenario: Add Id Card
    Given an existing administrator
    When the administrator goes to the id cards administration page
    And he goes to the new id card page
    And he adds an id card
    And he goes back to the id cards page
    Then the id card is added to the list

  @javascript
  Scenario: Don't show entity in id card section
    Given an existing administrator
    When the administrator goes to the id cards administration page
    Then he doesn't see the filter for entity
    And he goes to the new id card page
    Then he doesn't see the id card's entity select field

  @javascript
  Scenario: Show only id cards from same entity
    Given an existing entity
    And an existing administrator from this entity
    And an existing id card from the same entity
    And another existing entity
    And an existing id card from this other entity

    When the administrator is in the admin section
    And he goes to the id cards page
    Then he should see the id card from his entity
    And he should not see the id card from another entity
