namespace :carrierwave do
  task :uploads_folder do
    run "mkdir -p #{shared_path}/uploads"
    run "#{sudo} chmod 775 #{shared_path}/uploads"
  end
  after 'deploy:setup', 'carrierwave:uploads_folder'

  task :symlink do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  after 'deploy', 'carrierwave:symlink'
end
