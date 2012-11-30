namespace :deploy do
  desc 'Deploy & migrate'
  task :migrations do
    update
    migrate
    restart
  end

  desc 'Run migrations'
  task :migrate, :roles => :db, :only => {:primary => true} do
    run "cd #{deploy_to} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end
end