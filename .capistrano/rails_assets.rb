namespace :rails_assets do
  task :conditional_precompile, :roles => :web, :except => { :no_release => true } do
    conditions_for_precompile = [(capture("cd #{deploy_to} && ls log/deploy_history 2> /dev/null | wc -l ").to_i == 0)]
    conditions_for_precompile << (capture("cd #{deploy_to} && git diff --name-only HEAD@{1} HEAD vendor/assets/ app/assets/ | wc -l").to_i > 0)

    if conditions_for_precompile.any?
      run %Q{cd #{deploy_to} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile 2>&1}
    else
      logger.info "Skipping asset pre-compilation because there were no asset changes"
    end
  end

  task :precompile do
      run %Q{cd #{deploy_to} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile 2>&1}
  end
end

after 'deploy:update', 'rails_assets:conditional_precompile'
