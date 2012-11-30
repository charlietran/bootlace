namespace :cache do
  task :clear do
      run %Q{cd #{deploy_to} && RAILS_ENV=#{rails_env} rake cache:clear}
  end
end