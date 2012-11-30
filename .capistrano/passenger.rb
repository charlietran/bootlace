namespace :passenger do
  desc 'Restart passenger'
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "mkdir -p #{deploy_to}/tmp && touch #{File.join(deploy_to,'tmp','restart.txt')}"
    run "curl #{url} >/dev/null 2>&1" if exists?(:url)
  end
end

after 'deploy:restart', 'passenger:restart'