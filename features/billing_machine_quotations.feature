@javascript
Feature: Quotation Management
  As a user
  I want to create quotations
  In order to give them to my future customers

  Background:
    Given an existing id card

  Scenario: Existing quotation displayed in quotations page
    And an existing customer
    And an existing quotation
    When the user goes to the quotations page
    And the quotation line shows the right date
    And the quotation line shows the right traking-id
    And the quotation line shows the right customer's name
    And the quotation line shows the right total-duty value
    And the quotation line shows the right all taxes value

  Scenario: Paginate by 50 quotations
    Given 75 existing quotations
    When the user goes to the quotations page
    Then he should see 50 quotations
    When he goes to the next page
    Then he should see 25 quotations

  Scenario: Empty quotation
    And an existing emtpy quotation
    When the user goes to the quotations page
    Then the quotation is displayed correctly

  Scenario: Quotation details
    And an existing quotation
    When the user goes to the quotation details
    Then he can see all the quotation informations

  Scenario: New quotation for existing customer
    And an existing customer
    And an existing payment term
    When the user goes to the quotations page
    And he creates a new quotation
    And he fills the reference and the date
    And he chooses the customer
    And he fills an quotation line with "Bidule", "4", "€", "10"
    Then the new line's total should be "40,00€"
    And the quotation total duty is "40,00€"
    When he adds a new line
    And he fills an quotation line with "Machin truc", "8", "€", "20"
    Then the new line's total should be "160,00€"
    Then the quotation total duty is "200,00€"
    And the quotation VAT due is "40,00€"
    And the quotation total all taxes included is "240,00€"
    When he saves the quotation
    Then a message signals the success of the quotation creation
    Then it's added to the quotation list
    And the quotation informations are visible on the quotation details

  Scenario: Edit quotation
    And an existing quotation
    When the user goes to the quotation details
    And he goes on the edit page of the quotation
    And changes the quotation label
    When he saves the quotation
    Then a message signals the success of the quotation update
    Then the quotation's label has changed

  Scenario: New quotation with default date
    When the user goes to the quotations page
    And he creates a new quotation
    Then the quotation default date is set to today's date.

  Scenario: New quotation with default VAT rate
    When the user goes to the quotations page
    And he creates a new quotation
    Then the quotation VAT rate is "20"

  Scenario: Existing quotation with non default VAT rate
    And an existing quotation with a "19.6"% VAT rate
    And he goes on the edit page of the quotation
    Then the quotation VAT rate is "19.6"

  Scenario: New quotation with non default VAT rate
    When the user goes to the quotations page
    And he creates a new quotation
    And he fills an quotation line with "Bidule", "1", "€", "100"
    And he changes the quotation VAT rate to "19.6"
    Then the quotation VAT rate is "19.6"
    And the quotation VAT due is "19,60€"
    And the quotation total all taxes included is "119,60€"

  Scenario: Change quotation values without saving(test live preview)
    When the user goes to the quotations page
    And he creates a new quotation
    And he fills an quotation line with "Bidule", "2", "€", "50"
    Then the quotation new line total is "100,00€"
    And he fills an quotation line with "Bidule", "10", "€", "100"
    Then the existing quotation line total is "1.000,00€"
    And the quotation VAT due is "200,00€"
    And the quotation total all taxes included is "1.200,00€"
    And he changes the quotation VAT rate to "19.6"
    And the quotation VAT due is "196,00€"
    And the quotation total all taxes included is "1.196,00€"

  Scenario: Existing quotation has is associated documents shown on the show page
    And an existing quotation
    And 2 associated documents to this quotation
    When the user goes to the quotation details
    Then he will see links to the documents

  Scenario: Delete a document
    And an existing quotation
    And 2 associated documents to this quotation
    When the user goes to the quotation details
    And he delete a document
    Then a message signals the success of the quotation update
    And the document is not in the quotation details

  Scenario: Filter by customer
    Given a bunch of existing quotations
    When the user goes to the quotations page
    When he filters by one customer
    Then only the quotations of this customer do appear

  Scenario: Filter by date
    Given a bunch of existing quotations
    When the user goes to the quotations page
    When he filters by date on today
    Then only the quotations of today do appear
