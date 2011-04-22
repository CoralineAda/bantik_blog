@admin @post_to_blog

Feature: Post to blog
  In order to keep my blog up-to-date
  As an admin
  I want to create and manage blog posts

  Scenario: View empty list of blog posts
    Given I have a blog
    When I visit the admin blog posts page
    Then I should see "Blog Posts"
    And I should see "No published posts have been written."

  Scenario: View populated list of blog posts
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | state     |
      | foo          | Foo   | Foo is foo.  | draft     |
      | bar          | Bar   | Bar is bar.  | published |
    When I visit the admin blog posts page
    Then I should see "Blog Posts"
    And I should see "Bar"
    And I should not see "Foo"

  Scenario: Create a draft blog post
    Given I have a blog
    When I visit the admin blog posts page
    And I follow "New Post..."
    Then I should see "Create a New Post"
    And I fill in "post_title" with "My First Post"
    And I fill in "post_desired_slug" with "my-first-post"
    And I select "Draft" from "post_state"
    And I fill in "content_field" with "Blah blah blah"
    And I press "Save"
    Then I should see "About This Post"
    And I should see "My First Post"

  Scenario: Edit a blog post
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | state     |
      | foo          | Foo   | Foo is foo.  | published |
    When I visit the admin blog posts page
    And I follow "Edit" within "[@class='crud_links']"
    Then I should see "Edit a Post"
    And I fill in "post_title" with "My Earliest Post"
    And I press "Save"
    Then I should see "About This Post"
    And I should see "My Earliest Post"

  Scenario: Publish a blog post
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | state     |
      | foo          | Foo   | Foo is foo.  | published     |
    When I visit the admin blog posts page
    And I follow "Edit" within "[@class='crud_links']"
    And I press "Publish"
    Then I should see "About This Post"
    And I should see "Published"

  Scenario: Delete a blog post
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | state     |
      | foo          | Foo   | Foo is foo.  | published     |
    When I visit the admin blog posts page
    And I follow "Delete" within "[@class='crud_links']"
    Then I should see "Blog Posts"
    And I should not see "Foo"
