# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.13.0'

set :application, 'qna'
set :repo_url, 'git@github.com:shilovk/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

set :keep_releases, 3

set :sidekiq_queue, %w[default mailers active_storage_analysis]

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage', 'node_modules'

before 'deploy:updating', 'thinking_sphinx:stop'
after 'deploy:publishing', 'deploy:restart'
after 'deploy:published', 'thinking_sphinx:start'
after 'thinking_sphinx:start', 'thinking_sphinx:index'

namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
