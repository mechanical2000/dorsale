@javascript
Feature: PaymentTerm

  Scenario: New paymentterm
    Given an authenticated user
    And the user goes on the new paymentterm page
    When he fills the paymentterm's information
    And creates a new paymentterm
    Then he is redirected on the paymentterms page
    And the paymentterm is added to the paymentterm list

  Scenario: Update paymentterm
    Given an authenticated user
    And an existing paymentterm
    When the user edits the paymentterm
    Then the current paymentterm's label should be pre-filled
    When he validates the new paymentterm
    Then he is redirected on the paymentterms page
    And the paymentterm's label is updated
