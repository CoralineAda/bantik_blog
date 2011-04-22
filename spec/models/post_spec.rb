require File.dirname(__FILE__) + '/../spec_helper'

describe Post do

  before :all do
    @blog = Blog.make
  end

  it 'recognizes its draft status' do
    @blog.posts.new.draft?.should be_true
  end

  it 'returns its relative URL' do
    @blog.posts.new(:slug => 'foo').full_path.should == "/my-blog/foo/"
  end

  it 'returns its formatted slug' do
    @blog.posts.new(:slug => 'foo').humanize_path.should == "/foo/"
  end

  it 'publishes, setting its publication date' do
    post = @blog.posts.create(Post.make.attributes)
    post.publish!
    post.status.should == 'Published'
    post.publication_date.to_s(:concise).should == Time.now.to_s(:concise)
  end

  it 'unpublishes, clearing its publication date' do
    post = @blog.posts.create(Post.make.attributes)
    post.publish!
    post.unpublish!
    post.status.should == 'Draft'
    post.publication_date.nil?.should be_true
  end

  it 'defaults its desired slug to its title' do
    post = @blog.posts.new(
      :title => 'Test Post',
      :summary => 'Foo',
      :content => 'Bar'
    )
    post.save.should be_true
    post.slug.should == 'test-post'
  end

  describe 'full path' do

    before :each do
      Blog.delete_all
      Topic.delete_all
      @blog = Blog.make
    end

    it 'for a flat blog' do
      post = @blog.posts.create(
        :title => 'Test Post',
        :summary => 'Foo',
        :content => 'Bar',
        :desired_slug => 'test-post'
      )
      post.full_path.should == '/my-blog/test-post/'
    end

    it 'for a blog site' do
      @blog.update_attribute(:use_nested_paths, false)
      post = @blog.posts.create(
        :title => 'Test Post',
        :summary => 'Foo',
        :content => 'Bar',
        :desired_slug => 'test-post'
      )
      post.full_path.should == '/test-post/'
    end

    it 'for a blog with topics' do
      topic = @blog.topics.create!(Topic.make_unsaved.attributes.merge(:name => 'Foosball'))
      post = @blog.posts.create(
        :title => 'Test Post',
        :summary => 'Foo',
        :content => 'Bar',
        :desired_slug => 'test-post',
        :topic_id => topic._id
      )
      post.full_path.should == '/my-blog/foosball/test-post/'
    end

    describe 'nested blog' do

      it 'for a blog with nested paths' do
        Blog.destroy_all
        nested_blog = Blog.make(:use_nested_paths => true, :desired_slug => '/stuff/blog/')
        post = nested_blog.posts.create(
          :title => 'Test Post',
          :summary => 'Foo',
          :content => 'Bar',
          :desired_slug => 'test-post'
        )
        post.full_path.should == '/stuff/blog/test-post/'
      end

    end

  end
end
