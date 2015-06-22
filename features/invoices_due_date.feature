Feature: Invoice due date Management
  As a user
  I want to set due dates to my invoices
  And to be informed about late payements
  In order to know when to get angry!

  Background:
    Given an existing user
    
  @javascript
  Scenario: Existing invoice displayed in invoices page
  	Given an existing invoice
    When the user goes to the invoices page
    Then the invoice line shows the right date

  @javascript
  Scenario: Paid invoice green in list
    Given an existing paid invoice
    When the user goes to the invoices page
    Then the invoice status should be "paid"

  @javascript
  Scenario: Unpaid invoice with due date not passed have no color in list
    Given an existing unpaid invoice
    And its due date is not yet passed
    When the user goes to the invoices page
    Then the invoice paid status should not have a color

  @javascript
  Scenario: Unpaid invoice with due date the same day have no color in list
    Given an existing unpaid invoice
    And its due date is the same day
    When the user goes to the invoices page
    Then the invoice paid status should not have a color

  @javascript
  Scenario: Unpaid invoice with due date just passed appears orange in list
    Given an existing unpaid invoice
    And its due date is yesterday
    When the user goes to the invoices page
    Then the invoice status should be "late"

  @javascript
  Scenario: Unpaid invoice with due date passed by 15 days appears orange in list
    Given an existing unpaid invoice
    And its due date is 14 days ago
    When the user goes to the invoices page
    Then the invoice status should be "late"

  @javascript
  Scenario: Unpaid invoice with due date passed by 16 days appears red in list
    Given an existing unpaid invoice
    And its due date is 15 days ago
    When the user goes to the invoices page
    Then the invoice status should be "on_alert"
