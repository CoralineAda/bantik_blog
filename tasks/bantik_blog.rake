namespace :bantik_blog do

  desc "Install BantikBlog into your application."
  task :install do
    dir = Gem.searcher.find('bantik_blog').full_gem_path
    system "rsync -ruv #{dir}/config/initializers/bantik_blog.rb config/initializers/"
    system "rsync -ruv #{dir}/public/images/menu_icons public/images"
    system "rsync -ruv #{dir}/public/stylesheets/bantik_blog.css public/stylesheets"
    puts
    puts "========================================================================================="
    puts "BantikBlog installation complete."
    puts "========================================================================================="
    puts
    puts "Run rake bantik_blog:views if you want to customize views for your application."
    puts
    puts "========================================================================================="
    puts
  end

  desc "Copy views from BantikBlog into the host application"
  task :views do
    dir = Gem.searcher.find('bantik_blog').full_gem_path
    system "rsync -ruv #{dir}/app/views/blogs app/views/"
    system "rsync -ruv #{dir}/app/views/posts app/views/"
  end

end