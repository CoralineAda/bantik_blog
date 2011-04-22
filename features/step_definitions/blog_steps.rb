When /^I fill in a valid CAPTCHA$/ do
  controller.stubs(:verify_recaptcha).returns(true)
end

When /^I visit the url "([^"]*)"$/ do |url|
  visit url
end

When /^I visit the blog page$/ do
  visit '/my-blog/'
end

When /^I visit the blog search page$/ do
  visit '/my-blog/search'
end

When /^I visit the blog archive page$/ do
  visit '/my-blog/archive'
end

When /^I visit the blog RSS feed$/ do
  visit Blog.first.feed_address
end

When /^I visit the blog topics admin page$/ do
  visit "/admin/blogs/#{Blog.first._id}/topics"
end

When /^I visit the admin blog posts page$/ do
  visit "/admin/blogs/#{Blog.first._id}/posts"
end

When /^I visit the blog comments admin page$/ do
  visit "/admin/blogs/#{Blog.first._id}/comments"
end

Given /^I have a blog$/ do
  Blog.destroy_all
  Blog.create(:title => 'Default Blog', :desired_slug => 'my-blog', :description => 'My blog description')
end

Given /^I have a blog with topics$/ do
  Blog.destroy_all
  Blog.create(:title => 'Default Blog', :desired_slug => 'my-blog', :description => 'My blog description', :has_topics => true)
end

Given /the following blog comments exist:/ do |table|
  table.hashes.each do |hash|
    @comment = Blog.first.comments.create! hash
    @comment.post = Blog.first.posts.first
    @comment.save
  end
end

Given /the following blog posts exist:/ do |table|
  table.hashes.each{ |hash| Blog.first.posts.create hash }
end

Given /the following blog topics exist:/ do |table|
  Blog.first.topics.destroy_all
  table.hashes.each{ |hash| Blog.first.topics.create! hash }
end

Given /^no blogs exist$/ do
  Blog.destroy_all
end
