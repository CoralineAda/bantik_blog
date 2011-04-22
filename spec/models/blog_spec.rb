require File.dirname(__FILE__) + '/../spec_helper'

describe Blog do

  before :all do
    @blog = Blog.make
  end

  it "returns its feed address" do
    @blog.feed_address.should == "/my-blog/feed.rss"
  end

  it "returns its humanized path" do
    @blog.humanize_path.should == "/my-blog/"
  end

  it "retrieves posts by month" do
    today = Time.zone.now
    post = @blog.posts.create(Post.make_unsaved.attributes)
    posts = @blog.posts_by_month
    posts[today.to_s(:year_month)][:full_date].should == today.to_s(:month_year)
    posts[today.to_s(:year_month)][:posts].count.should == 1
  end

  it "searches its published posts" do
    post_1 = @blog.posts.create(Post.make_unsaved(:content => 'foo').attributes)
    post_2 = @blog.posts.create(Post.make_unsaved(:content => 'bar').attributes)
    @blog.search('foo').should == [post_1]
  end

end
