Rails.application.routes.draw do

  resources :comments

  resources :topics, :only => [:show]
  resources :blogs
  resources :posts, :only => [:show]

  class SimpleBlogConstraint
    def initialize; end
    def matches?(request)
      blog = Blog.where(:slug => request.path.split('/')[1]).first
      blog && ! blog.has_topics?
    end
  end

  class ComplexBlogConstraint
    def initialize; end
    def matches?(request)
      blog = Blog.where(:slug => request.path.split('/')[1]).first
      blog && blog.has_topics?
    end
  end

  constraints(SimpleBlogConstraint.new) do
    match ':blog_slug', :to => 'blogs#show', :via => :get
    match ':blog_slug/archive', :to => 'blogs#archive', :via => :get
    match ':blog_slug/search', :to => 'blogs#search', :as => :search_blog, :via => :get
    match ':blog_slug/feed', :to => 'blogs#feed', :format => [:rss], :via => :get
    match ':blog_slug/:post_slug', :to => 'posts#show', :via => :get
  end

  constraints(ComplexBlogConstraint.new) do
    match ':blog_slug', :to => 'blogs#show', :via => :get
    match ':blog_slug/archive', :to => 'blogs#archive', :via => :get
    match ':blog_slug/search', :to => 'blogs#search', :as => :search_blog, :via => :get
    match ':blog_slug/feed', :to => 'blogs#feed', :format => [:rss], :via => :get
    match ':blog_slug/:topic_slug/', :to => 'topics#show', :via => :get
    match ':blog_slug/:topic_slug/:subtopic_slug/', :to => 'topics#show', :via => :get
    match ':blog_slug/:topic_slug/:subtopic_slug/:post_slug', :to => 'posts#show', :via => :get
  end

  class AdminConstraint
    def initialize; end
    def matches?(request)
      request.subdomain =~ /admin/
    end
  end

  constraints(AdminConstraint.new) do
    namespace :admin do
      resources :blogs do
        resources :comments do
          member do
            get :approve
            get :reject
          end
        end
        resources :posts
        resources :topics do
          collection do
            post :reorder
            post :restructure
          end
        end
      end
    end
  end
end
