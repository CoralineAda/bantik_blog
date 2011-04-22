@admin @topics
Feature: Manage Blog Topics

  In order to keep my blog organized
  As an admin
  I want to set up and manage blog topics

  Scenario: View empty list of blog topics
    Given I have a blog
    When go to the admin_blogs page
    And I follow "Manage Topics"
    Then I should see "Blog Topics"
    And I should see "No topics have been created yet."

  Scenario: View populated list of blog topics
    Given I have a blog
    Given the following blog topics exist:
      | name    | short_description   | description       |
      | Stuff   | All kinds.          | All kindsa stuff. |
      | Things  | Several varieties.  | Take your pick.   |
    When I visit the blog topics admin page
    Then I should see "Blog Topics"
    And I should see "Stuff"
    And I should see "Things"

  Scenario: Create a blog topic
    Given I have a blog
    When go to the admin_blogs page
    And I follow "Manage Topics"
    And I follow "New Topic..."
    Then I should see "Create a New Blog Topic"
    And I fill in "topic_name" with "My First Topic"
    And I fill in "topic_short_description" with "Blah blah blah"
    And I fill in "topic_description" with "Blah blah blah and more."
    And I press "Save"
    Then I should see "Blog Topics"
    And I should see "My First Topic"

  Scenario: Edit a blog topic
    Given I have a blog
    Given the following blog topics exist:
      | name    | short_description   | description       |
      | Stuff   | All kinds.          | All kindsa stuff. |
    When go to the admin_blogs page
    And I follow "Manage Topics"
    And I follow "Edit" within "[@class='crud_links']"
    Then I should see "Edit a Blog Topic"
    And I fill in "topic_short_description" with "Every kind"
    And I press "Save"
    And I follow "Stuff"
    Then I should see "Every kind"

  Scenario: Delete a blog topic
    Given I have a blog
    Given the following blog topics exist:
      | name    | short_description   | description       |
      | Stuff   | All kinds.          | All kindsa stuff. |
    When go to the admin_blogs page
    And I follow "Manage Topics"
    And I follow "Delete" within "[@class='crud_links']"
    Then I should see "Blog Topics"
    And I should not see "Foo"
