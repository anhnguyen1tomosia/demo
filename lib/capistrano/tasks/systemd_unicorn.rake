namespace :systemd_unicorn do
  task :restart, :clear_cache do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :unicorn
    end
  end
end
