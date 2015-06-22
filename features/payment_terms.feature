Feature: Payment Terms Management
  As an administrator
  I want to create payment terms
  In order to use them in the invoices module

  @javascript
  Scenario: Add Payment Term
    Given an existing administrator
    When the administrator goes to the payment terms administration page
    And he goes to the new payment term page
    And he adds a payment term
    And he goes to the invoices page
    And he creates a new invoice
    Then the payment term is added to the list

  @javascript
  Scenario: Don't show entity in payment term section
    Given an existing administrator
    When the administrator goes to the payment terms administration page
    Then he doesn't see the filter for entity
    When he goes to the new payment term page
    Then he doesn't see the payment term's entity select field

  @javascript
  Scenario: Show only payment terms from same entity
    Given an existing entity
    And an existing administrator from this entity
    And an existing payment term from the same entity
    And another existing entity
    And an existing payment term from this other entity

    When the administrator is in the admin section
    And he goes to the payment terms page
    Then he should see the payment term from his entity
    And he should not see the payment term from another entity
