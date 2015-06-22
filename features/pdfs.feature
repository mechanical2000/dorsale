Feature: Pdfs Management
  As a user
  I want to download
  In order to keep data on my computer

  Background:
  Given an existing user
  Given an existing customer
  Given an existing invoice

  @javascript
  Scenario: Invoice has a link to download pdf
    When the user goes to the invoice details
    Then he can see the pdf download button

  Scenario: Invoice Pdf with valid name
    When the user download the pdf
    Then the Pdf should have the filename "Facture_1401_AC.pdf"
