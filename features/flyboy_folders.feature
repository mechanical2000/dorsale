@javascript
Feature: Manage folders
  Background:
    Given an existing user

  Scenario: Create a folder
    When I go to the folders section
    And I create a new folder
    Then I am on the created folder
    And the folder is created
    And the folder is opened

  Scenario: Read a folder
    Given an existing folder
    And 3 tasks in this folder
    When I consult this folder
    Then I see this folder
    And I see the folder tasks

  Scenario: Update a folder
    Given an existing folder
    When I go to the folders section
    And I update this folder
    Then I am on the updated folder
    And the folder is updated

  Scenario: Delete a folder
    Given an existing folder
    When I go to the folders section
    And I delete this folder
    Then I am on the folders section
    And the folder is deleted

  Scenario: Close a folder
    Given an existing folder
    When I close this folder
    Then I am on the folders section
    And the folder is closed

  Scenario: Reopen a folder
    Given an existing closed folder
    When I reopen this folder
    Then I am on this folder
    And the folder is opened

  Scenario: Filter folders
    Given an existing open folder
    And an existing closed folder
    When I go to the folders section
    And I filter folders by open
    Then only open folders appear
    When I filter folders by closed
    Then only closed folders appear
    When I reset filters
    Then all folders appear

  Scenario: Search folders
    Given an existing folder named "Hello"
    And an existing folder named "World"
    When I go to the folders section
    And I search "Hello"
    Then only the "Hello" folder appear

  Scenario: Folders pagination
    Given 100 existing folders
    When I go to the folders section
    Then folders are paginated

  Scenario: Filter by name asc
    Given an existing folder
    Given 3 tasks to sort in this folder
    When I consult this folder
    And I sort tasks by "name" "asc"
    Then tasks are sorted by "name" "asc"

  Scenario: Filter by name desc
    Given an existing folder
    Given 3 tasks to sort in this folder
    When I consult this folder
    And I sort tasks by "name" "desc"
    Then tasks are sorted by "name" "desc"

  Scenario: Filter by progress asc
    Given an existing folder
    Given 3 tasks to sort in this folder
    When I consult this folder
    And I sort tasks by "progress" "asc"
    Then tasks are sorted by "progress" "asc"

  Scenario: Filter by progress desc
    Given an existing folder
    Given 3 tasks to sort in this folder
    When I consult this folder
    And I sort tasks by "progress" "desc"
    Then tasks are sorted by "progress" "desc"

  Scenario: Filter by term asc
    Given an existing folder
    Given 3 tasks to sort in this folder
    When I consult this folder
    And I sort tasks by "term" "asc"
    Then tasks are sorted by "term" "asc"

  Scenario: Filter by term desc
    Given an existing folder
    Given 3 tasks to sort in this folder
    When I consult this folder
    And I sort tasks by "term" "desc"
    Then tasks are sorted by "term" "desc"
