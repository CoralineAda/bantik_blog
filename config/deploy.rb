# Deploy this gem to the gem server.
#
# Usage for a gem already on the gem server:
#
#   cap deploy
#
# For a new gem:
#
#   cap deploy:new

# Global Variables =================================================================================
default_run_options[:pty] = true
role :app, 'jose.seologic.com'
set :deploy_to, '/home/containers/rails/system/bantik_blog'
set :repository, 'git@github.com:Bantik/bantik_blog.git'
set :scm, :git
set :use_sudo, false
set :user, 'cnewton'

namespace :deploy do
  desc "Clone a new gem's repository on the gem server."
  task :new do
    run "git clone -q #{repository} #{deploy_to}"
  end

  task :install do
    run "cd #{deploy_to}; rm -f Gemfile.lock; sudo bundle; sudo rake install"
  end

  # disable default behavior
  task :restart do
  end

  task :update do
    run "cd #{deploy_to}; git pull"
  end
end

after 'deploy', 'deploy:install'
after 'deploy:new', 'deploy:install'
