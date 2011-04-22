@admin
Feature: Manage Blog

  In order to keep my site full of fresh content
  As an admin
  I want to set up and manage a blog

  Scenario: Create a blog
    Given no blogs exist
    When go to the admin_blogs page
    And I follow "Set Up Blog"
    And I fill in "Blog Title" with "Adventures at 7-11"
    And I fill in "URL" with "7-11-adventures"
    And I fill in "Description" with "An epic tale of strange stuff that happens at my local convenience store."
    And I select "10" from "Posts Per Page"
    And I press "Save"
    Then I should see "Successfully set up the blog."
    And I should see "Adventures at 7-11"
    And I should see "An epic tale of strange stuff that happens at my local convenience store."
    And I should see "10"

  Scenario: Edit a blog
    Given I have a blog
    When go to the admin_blogs page
    And I follow "Blog Configuration"
    Then I should see "Blog Details"
    And I follow "Edit"
    And I fill in "Blog Title" with "Adventures at Circle K"
    And I press "Save"
    Then I should see "Successfully modified the blog."
    And I should see "Adventures at Circle K"

