set :application, "AppName"
set :repository,  "git@host.com:/repo.git"

load '.capistrano/multistage'
set :default_stage, "staging"

stage :dev do
  server '255.255.255.255', :app, :web, :db, :primary => true
  set :user, "user"
  set :deploy_to, "/home/user/folder"
  set :deploy_env, 'staging'
  set :rails_env, 'staging'
  set :branch, 'dev'
  set :url, "http://google.com"
end

stage :production do
  server '255.255.255.0', :app, :web, :db, :primary => true
  set :user, "user"
  set :deploy_to, "/home/user/folder"
  set :deploy_env, 'production'
  set :rails_env, 'production'
  set :branch, 'master'
  set :url, "http://google.com"
end

#########################################

load '.capistrano/git'

## Rails
# load '.capistrano/bundle'
# load '.capistrano/passenger'
# load '.capistrano/rails'
# load '.capistrano/rails_assets'
# load '.capistrano/delayed_job'
# load '.capistrano/cache'