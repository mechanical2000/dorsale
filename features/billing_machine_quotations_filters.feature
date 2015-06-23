Feature: Quotations filter
  As a user
  I want to filter quotations
  In order to understand what it going on

  Background:
    And a bunch of existing quotations
    When the user goes to the quotations page

  Scenario: Filter by customer
    When he filters by one customer
    Then only the quotations of this customer do appear

  Scenario: Filter by date
    When he filters by date on today
    Then only the quotations of today do appear
