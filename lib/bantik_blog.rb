module BantikBlog

  require 'mongoid'
  require 'bantik_blog/engine' if defined?(Rails)
  require 'bantik_blog/railtie' if defined?(Rails)
  require 'bantik_blog/base'
  require 'bantik_blog/import'

  def self.setup
    yield self
  end

end
