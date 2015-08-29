set :application, 'twist'
set :repo_url, 'git://github.com/radar/twist'
set :deploy_to, '/var/www/twist'
set :bundle_flags, '--deployment'
set :linked_files, %w{config/initializers/mail.rb}
set :linked_dirs, %w{log}

set :chruby_ruby, 'ruby-2.2.3'

set :rbenv_map_bins, %w{rake gem bundle ruby rails}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, "service unicorn-twist restart"
    end
  end

  after :finishing, 'deploy:cleanup'

end
