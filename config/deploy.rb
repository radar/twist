set :application, 'twist'
set :repo_url, 'git://github.com/radar/twist'
set :deploy_to, '/var/www/twist'
set :bundle_flags, '--deployment'
set :linked_files, %w{config/initializers/mail.rb config/database.yml}
set :linked_dirs, %w{log tmp public/system repos}

set :chruby_ruby, 'ruby-2.5.0'

namespace :yarn do
  task :install do
    on roles(:app) do
      within release_path do
        execute :yarn, "install"
      end
    end
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, "service unicorn-twist restart"
      execute :sudo, "service sidekiq-twist restart"
    end
  end

  desc 'Compile webpacker assets'
  task :webpack_compile do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "webpacker:compile"
        end
      end
    end
  end

  before 'deploy:updated', 'yarn:install'
  after "deploy:updated", "deploy:webpack_compile"
  after "deploy:published", "deploy:restart"
  after :finishing, 'deploy:cleanup'
end
