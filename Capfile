# frozen_string_literal: true

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or

require 'capistrano/rbenv'
require 'capistrano/bundler'
# require 'capistrano/rails/assets' # rollback RU-302
require 'capistrano3/unicorn'
# require 'capistrano/yarn'
require 'capistrano/upload-config'
# require 'whenever/capistrano'

# set :rbenv_type, :user
# set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_ruby, '2.7.0'
# set :rbenv_roles, :all
# set :log_level, :warn


# require 'capistrano/nvm'
# set :nvm_type, :user # or :system, depends on your nvm setup
# set :nvm_node, 'v10.23.0'
# set :nvm_map_bins, %w[node npm yarn]

require 'capistrano/scm/git'
# require 'capistrano/scm/git-with-submodules'
install_plugin Capistrano::SCM::Git
# install_plugin Capistrano::SCM::Git::WithSubmodules
# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require "capistrano/rvm"
# require "capistrano/rbenv"
# require "capistrano/chruby"
# require "capistrano/bundler"
# require 'capistrano/rails/assets'
# require "capistrano/rails/migrations"
# require "capistrano/passenger"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
