lock "3.2.1"

set :rvm_ruby_string, "ruby-2.1.4@homecooks"
set :rvm_type, :user
set :application, "home_cooks"
set :service, "homecooks"
set :repo_url, "git@github.com:skier2k5/#{fetch(:application)}.git"
set :branch, "master"
set :use_sudo, false
set :pty, true
set :systemd_dir, "~/.config/systemd/user"

set :deploy_to, "/deploy/#{fetch(:application)}"
set :log_level, :debug

namespace :deploy do
  desc "Install new crontab"
  task :install_cron do
    on roles(:app) do
      execute "crontab #{release_path}/config/crontab"
    end
  end

  desc "Restart phusion with nginx"
  task :restart_phusion do
    on roles(:app) do
      execute "mkdir -p #{current_path}/tmp"
      execute "touch #{current_path}/tmp/restart.txt"
    end
  end

  after :migrate, :install_cron
  after :install_cron, :restart_phusion
end
