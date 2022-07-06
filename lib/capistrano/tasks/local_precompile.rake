namespace :load do
  task :defaults do
    set :assets_dir,       "public/assets"
    set :packs_dir,        "public/packs"
    set :rsync_cmd,        "rsync -avz"
    set :assets_role,      "web"
    set :compilation_dir,  "tmp/cache/webpacker"

    after "bundler:install", "deploy:assets:prepare"
    after "deploy:assets:prepare", "deploy:assets:rsync"
    after "deploy:assets:rsync", "deploy:assets:cleanup"
    after "deploy:assets:cleanup", "deploy:assets:compilation"
  end
end

namespace :deploy do
  namespace :assets do
    desc "Remove all local precompiled assets"
    task :cleanup do
      run_locally do
        execute "rm", "-rf", fetch(:assets_dir)
        execute "rm", "-rf", fetch(:packs_dir)
      end
    end

    desc "Actually precompile the assets locally"
    task :prepare do
      run_locally do
        precompile_env = fetch(:precompile_env) || fetch(:rails_env) || 'production'
        execute "RAILS_ENV=#{fetch(:rails_env)} bundle exec rake assets:clean"
        execute "rm", "-rf", fetch(:compilation_dir)
        execute "RAILS_ENV=#{fetch(:rails_env)} bundle exec rake assets:precompile"
      end
    end

    desc "Performs rsync to app servers"
    task :rsync do
      on roles(fetch(:assets_role)), in: :parallel do |server|
        run_locally do
          remote_shell = %(-e "ssh -i #{fetch(:ssh_options)[:keys].first}")

          commands = []
          commands << "#{fetch(:rsync_cmd)} #{remote_shell} ./#{fetch(:assets_dir)}/ #{server.user}@#{server.hostname}:#{release_path}/#{fetch(:assets_dir)}/" if Dir.exists?(fetch(:assets_dir))
          commands << "#{fetch(:rsync_cmd)} #{remote_shell} ./#{fetch(:packs_dir)}/ #{server.user}@#{server.hostname}:#{release_path}/#{fetch(:packs_dir)}/" if Dir.exists?(fetch(:packs_dir))

          commands.each do |command|
            if dry_run?
              SSHKit.config.output.info command
            else
              execute command
            end
          end
        end
      end
    end

    task :compilation do
      on roles(fetch(:assets_role)), in: :parallel do |server|
        run_locally do
          remote_shell = %(-e "ssh -i #{fetch(:ssh_options)[:keys].first}")
          compilation_file = "last-compilation-digest-#{fetch(:rails_env)}"
          commands = []
          commands << "#{fetch(:rsync_cmd)} #{remote_shell} ./#{fetch(:compilation_dir)}/#{compilation_file} #{server.user}@#{server.hostname}:#{release_path}/#{fetch(:compilation_dir)}/"

          commands.each do |command|
            if dry_run?
              SSHKit.config.output.info command
            else
              execute command
            end
          end
        end
      end
    end
  end
end
