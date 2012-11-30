namespace :delayed_job do
  def rails_env
    fetch(:rails_env, false) ? "RAILS_ENV=#{fetch(:rails_env)}" : ''
  end

  def delayed_job_args
    fetch(:delayed_job_args, "")
  end

  def roles
    fetch(:delayed_job_server_role, :app)
  end

  desc "Stop the delayed_job process"
  task :stop, :roles => lambda { roles } do
    run "cd #{deploy_to};#{rails_env} script/delayed_job stop"
  end

  desc "Start the delayed_job process"
  task :start, :roles => lambda { roles } do
    run "cd #{deploy_to};#{rails_env} script/delayed_job start #{delayed_job_args}"
  end

  desc "Restart the delayed_job process"
  task :restart, :roles => lambda { roles } do
    run "cd #{deploy_to};#{rails_env} script/delayed_job restart #{delayed_job_args}"
  end
end

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
