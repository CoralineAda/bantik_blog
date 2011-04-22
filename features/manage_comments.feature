@admin @comments
Feature: Manage Blog Comments

  In order to keep my blog social
  As an admin
  I want to approve and reject comments

  Scenario: No pending blog comments
    Given I have a blog
    When I visit the blog comments admin page
    Then I should see "There are no pending comments."

  Scenario: Pending blog comments
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     |
      | foo          | Foo   | Foo is foo.  | First   | published |
    Given the following blog comments exist:
      | author | author_email   | content         |
      | Ewige  | ewige@test.com | Great article.  |
    When I visit the blog comments admin page
    And I should see "Ewige"
    And I should see "Great article"

  Scenario: Approve a blog comment
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     |
      | foo          | Foo   | Foo is foo.  | First   | published |
    Given the following blog comments exist:
      | author | author_email   | content         |
      | Ewige  | ewige@test.com | Great article.  |
    When I visit the blog comments admin page
    And I follow "Approve" within "[@class='crud_links']"
    Then I should see "There are no pending comments."

  Scenario: Reject a blog comment
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     |
      | foo          | Foo   | Foo is foo.  | First   | published |
    Given the following blog comments exist:
      | author | author_email   | content         |
      | Ewige  | ewige@test.com | Great article.  |
    When I visit the blog comments admin page
    And I follow "Reject" within "[@class='crud_links']"
    Then I should see "There are no pending comments."
