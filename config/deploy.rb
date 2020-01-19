# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, 'thermostat'
set :repo_url, 'git@github.com:jeffmcfadden/PiThermostat.git'

# Default branch is :master
set :branch, ENV.fetch('REVISION', 'master')

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/www/thermostat'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml', 'config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# set the locations that we will look for changed assets to determine whether to precompile
set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)


# clear the previous precompile task
Rake::Task["deploy:assets:precompile"].clear_actions
class PrecompileRequired < StandardError; end

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  namespace :services do
    desc "Restart All Services"
    task :restart do
      on roles(:web) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute "sudo systemctl restart puma.service"
            #" || sudo service puma restart || sudo service puma start"
          end
        end
      end
      on roles(:background) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute "sudo systemctl restart sidekiq"
          end
        end
      end
    end
  end

  namespace :assets do
    desc "Precompile assets"
    task :precompile do
      on roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            begin
              # find the most recent release
              latest_release = capture(:ls, '-xr', releases_path).split[1]

              # precompile if this is the first deploy
              raise PrecompileRequired unless latest_release

              latest_release_path = releases_path.join(latest_release)

              # precompile if the previous deploy failed to finish precompiling
              execute(:ls, latest_release_path.join('assets_manifest_backup')) rescue raise(PrecompileRequired)

              fetch(:assets_dependencies).each do |dep|
                # execute raises if there is a diff
                execute(:diff, '-Naur', release_path.join(dep), latest_release_path.join(dep)) rescue raise(PrecompileRequired)
              end

              info("Skipping asset precompile, no asset diff found")

              # copy over all of the assets from the last release
              execute(:cp, '-r', latest_release_path.join('public', fetch(:assets_prefix)), release_path.join('public', fetch(:assets_prefix)))
            rescue PrecompileRequired
              execute(:rake, "assets:precompile")
            end
          end
        end
      end
    end
  end

end

after  "deploy:published", "deploy:services:restart"
# after "deploy:updated", "newrelic:notice_deployment"