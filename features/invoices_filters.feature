Feature: Invoices filter
  As a user
  I want to filter invoice
  In order to understand what it going on

  Background: 
    Given an existing user
    And a bunch of existing invoices
    When the user goes to the invoices page
    
  Scenario: Filter by customer
    When he filters by one customer
    Then only the invoices of this customer do appear

  Scenario: Filter by date
    When he filters by date on today
    Then only the invoices of today do appear

  Scenario: Filter by status
    When he filters by status on paid
    Then only the invoices paid do appear