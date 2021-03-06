# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'awesome_events'
set :repo_url, 'git@github.com:tsub/awesome_events.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :deploy_to, '/var/www/awesome_events'

# Default value for :scm is :git
# set :scm, :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('.env')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('tmp/pids')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { rbenv_root: '/home/ops/.rbenv', path: '/home/ops/.rbenv/shims:/home/ops/.rbenv/bin:$PATH' }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :keep_releases, 5

# Unicorn周りの設定
set :unicorn_rack_env, 'none'
set :unicorn_config_path, 'config/unicorn.rb'

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
