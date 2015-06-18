@javascript
Feature: Manage goals
  Scenario: Create a goal
    When I go to the goals section
    And I create a new goal
    Then I am on the created goal
    And the goal is created
    And the goal is opened

  Scenario: Read a goal
    Given an existing goal
    And 3 tasks in this goal
    When I consult this goal
    Then I see this goal
    And I see the goal tasks

  Scenario: Update a goal
    Given an existing goal
    When I go to the goals section
    And I update this goal
    Then I am on the updated goal
    And the goal is updated

  Scenario: Delete a goal
    Given an existing goal
    When I go to the goals section
    And I delete this goal
    Then I am on the goals section
    And the goal is deleted

  Scenario: Close a goal
    Given an existing goal
    When I close this goal
    Then I am on the goals section
    And the goal is closed

  Scenario: Reopen a goal
    Given an existing closed goal
    When I reopen this goal
    Then I am on this goal
    And the goal is opened

  Scenario: Filter goals
    Given an existing open goal
    And an existing closed goal
    When I go to the goals section
    And I filter goals by open
    Then only open goals appear
    When I filter goals by closed
    Then only closed goals appear
    When I reset filters
    Then all goals appear

  Scenario: Search goals
    Given an existing goal named "Hello"
    And an existing goal named "World"
    When I go to the goals section
    And I search "Hello"
    Then only the "Hello" goal appear

  Scenario: Goals pagination
    Given 100 existing goals
    When I go to the goals section
    Then goals are paginated
