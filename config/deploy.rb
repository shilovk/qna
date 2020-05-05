# config valid for current version and patch releases of Capistrano
lock '~> 3.13.0'

set :application, 'qna'
set :repo_url, 'git@github.com:shilovk/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

set :sidekiq_queue, %w[default mailers]

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage', 'node_modules'

after 'thinking_sphinx:start', 'thinking_sphinx:index'
