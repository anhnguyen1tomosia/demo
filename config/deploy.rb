# frozen_string_literal: true

# require 'config'
# Config.load_and_set_settings(File.join(File.expand_path('../..', __FILE__),
#                                        'config', "settings.local.#{fetch(:stage)}.yml"))

# config valid for current version and patch releases of Capistrano
lock '3.17.0'
server 'companytools-staging3.daijob.com', user: 'ubuntu', roles: %w[app db web]
set :application, 'daijob6_demo'
set :repo_url, 'git@github.com:anhnguyen1tomosia/demo.git'

set :deploy_to, "/home/ubuntu/dist/daijob6_demo"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 10

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
# set :pty, true

# set :default_env, {
#   "PATH": "/home/#{Settings.deploy.user_name}/.nvm/versions/node/v10.23.0/bin:$PATH"
# }

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/master.key',
                                                 'config/unicorn.rb')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', "public/system")

# set :config_files, %w[config/database.yml config/master.key config/settings.local.yml
#                       config/nginx-daijob.conf config/unicorn.rb config/unicorn_daijob
#                       config/wildcard.daijob.com.crt config/wildcard.daijob.com.key
#                       config/wildcard.daijob.com.chained.crt]

set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, -> { File.join(current_path, 'config', 'unicorn.rb') }
# set :bundle_path, -> { shared_path.join('vendor/bundle') }

# rollback RU-302
# https://github.com/daijob/daijob6_companytools/pull/997/files
# set :assets_dir,       "public/assets"
# set :packs_dir,        "public/packs"

namespace :deploy do
  # rollback RU-302
  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  end

  # desc "Precompile assets locally and then rsync to web servers"
  # desc "Remove all local precompiled assets"
  # task :cleanup_local_files do
  #   run_locally do
  #     execute "rm", "-rf", fetch(:assets_dir)
  #     execute "rm", "-rf", fetch(:packs_dir)
  #   end
  # end
  #
  # desc "Actually precompile the assets locally"
  # task :compile_assets_locally do
  #   run_locally do
  #     with rails_env: fetch(:stage) do
  #       execute 'bundle exec rails assets:clean'
  #       execute 'bundle exec rails assets:precompile'
  #     end
  #   end
  # end
  #
  # desc "Zip assets and packs"
  # task :zip_assets_locally do
  #   run_locally do
  #     execute 'tar -zcvf ./tmp/assets.tar.gz ./public/assets 1> /dev/null'
  #     execute 'tar -zcvf ./tmp/packs.tar.gz ./public/packs 1> /dev/null'
  #   end
  # end
  #
  # desc "Send zip file to server"
  # task :send_assets_zip do
  #   on roles(:web) do |_host|
  #     upload!('./tmp/assets.tar.gz', "#{release_path}/public/")
  #     upload!('./tmp/packs.tar.gz', "#{release_path}/public/")
  #   end
  # end
  #
  # desc "Unzip sent file on server"
  # task :unzip_assets do
  #   on roles(:web) do |_host|
  #     execute "cd #{release_path}; tar -zxvf #{release_path}/public/assets.tar.gz 1> /dev/null"
  #     execute "cd #{release_path}; tar -zxvf #{release_path}/public/packs.tar.gz 1> /dev/null"
  #   end
  # end
# end

# rollback RU-302
# どのタイミングでタスクが呼ばれるのかを記述する。
# before 'deploy:updated', 'deploy:cleanup_local_files'
# before 'deploy:updated', 'deploy:compile_assets_locally'
# before 'deploy:updated', 'deploy:zip_assets_locally'
# before 'deploy:updated', 'deploy:send_assets_zip'
# before 'deploy:updated', 'deploy:unzip_assets'

# note
# How to build with webpack
# (1) bin/webpack(-dev-server)
# (2) bundle exec rake webpacker:compile
# (3) bundle exec rake assets:precompile
#
# (1)(2) is provided by gem webpacker or rake task.
# webpacker hooks assets:precompile.
# so (3) is executed then (2) will be called.
