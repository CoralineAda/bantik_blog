@browse_blog

Feature: Browse blog

  In order to learn more
  As a public user
  I want to browse the blog

  Scenario: Access the blog page
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     |
      | foo          | Foo   | Foo is foo.  | First   | published |
      | bar          | Bar   | Bar is bar.  | Second  | draft     |
    When I visit the blog page
    Then I should see "Default Blog"
    And I should see "My blog description"
    And I should see "Foo"
    And I should see "First"
    And I should not see "Bar"

  Scenario: View published blog post
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     |
      | foo          | Foo   | Foo is foo.  | First   | published |
    When I visit the blog page
    And I follow "Read More..."
    Then I should see "Foo"
    And I should see "Foo is foo."

  Scenario: Search for blog posts
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     |
      | foo          | Foo   | Foo is foo.  | First   | published |
    When I visit the blog search page
    And I fill in "keyword" with "foo"
    And I press "GO"
    Then I should see "Search Results (1)"
    And I should see "Foo"
    And I should see "First"

  Scenario: Access the archive
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     | publication_date |
      | foo          | Foo   | Foo is foo.  | First   | published | 2011-03-22       |
    When I visit the blog archive page
    Then I should see "March 2011"
    And I should see "Foo"

  Scenario: Access the RSS feed
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     | publication_date |
      | foo          | Foo   | Foo is foo.  | Short   | published | 2011-03-22       |
    When I visit the blog RSS feed
    Then I should see "Foo"
    And I should see "Short"

  Scenario: Access a topic page
    Given I have a blog with topics
    Given the following blog topics exist:
      | name    | short_description   | description       |
      | Stuff   | All kinds.          | All kindsa stuff. |
      | Things  | Several varieties.  | Take your pick.   |
    When I visit the url "/my-blog/stuff/"
    Then I should see "Stuff"
    And I should see "All kindsa stuff."

  Scenario: Leave a comment on a blog post
    Given I have a blog
    Given the following blog posts exist:
      | desired_slug | title | content      | summary | state     |
      | foo          | Foo   | Foo is foo.  | First   | published |
    When I visit the blog page
    And I follow "Read More..."
    Then I should see "Leave a Comment"
    And I fill in "Name" with "Ewige"
    And I fill in "Email" with "ewige@test.com"
    And I fill in "Comment" with "Great post!"
    And I fill in a valid CAPTCHA
    And I press "Submit"
    Then I should see "Your comment has been submitted for approval."

