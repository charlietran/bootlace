set :enable_submodules, false # git submodules

namespace :deploy do
  task :default do
    update
    restart
  end

  desc 'Setup'
  task :setup, :except => {:no_release => true} do
    run "mkdir -p `dirname #{deploy_to}` && git clone --no-checkout #{repository} #{deploy_to}"
    run "cd #{deploy_to}; git fetch; git checkout --track -b #{branch} origin/#{branch}"
    update
  end

  desc 'Update the deployed code'
  task :update, :except => {:no_release => true} do
    commit = ENV['COMMIT'] || "origin/#{branch}"
    command = ["cd #{deploy_to}", 'git fetch origin 2>&1', "git reset --hard #{commit} 2>&1"]
    command += ['git submodule init', 'git submodule -q sync', 'git submodule -q update'] if enable_submodules
    command += ["mkdir -p #{deploy_to}/log", 'touch log/deploy_history', "echo `date` '|' `git rev-parse HEAD` >> log/deploy_history"]
    run command.join(' && ')
  end

  task :restart do

  end
end
