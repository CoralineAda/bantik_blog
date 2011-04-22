require 'bantik_blog'
require 'rails'
module BantikBlog
  class Railtie < Rails::Railtie
    rake_tasks do
      dir = Gem.searcher.find('bantik_blog').full_gem_path
      load "#{dir}/tasks/bantik_blog.rake"
    end
  end
end