Feature: Invoice due date emails
  As a user
  For the invoices
  I want to receive emails about the very late payments
  In order to know when to get really angry!

  Background:
    Given an existing user who wants to be notified about late invoices payments

  Scenario: Email when due date passed by 16 days
    Given an existing unpaid invoice
    And its due date is 16 days ago
    Given an existing paid invoice    
    When the nightly cron runs
    Then the user is notified
