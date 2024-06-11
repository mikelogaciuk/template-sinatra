require 'yaml'

desc 'Database'
namespace :database do
  desc 'Destroy'
  task :destroy do
    `rm ./database/local.db`
  end
end

desc 'Run API in different forms (docker, dev, prod)'
namespace :run do
  namespace :docker do
    desc 'Run Docker instance'
    task :up do
      `docker compose up -d`
    end
    desc 'Teardown'
    task :destroy do
      `docker compose down -v`
    end
  end

  desc 'Run local development instance'
  task :dev do
    `puma config.ru -C puma.rb`
  end

  desc 'Run local production instance'
  task :prod do
    `puma config.ru -C puma.rb -e production`
  end
end
