@javascript
Feature: People invoices
  Background:
    Given an authenticated user

  Scenario: List person invoices
    Given an existing corporation
    And this corporation has an invoice
    When he go on he corporation invoices page
    Then he should see 1 invoices
