node[:deploy].each do |application, deploy|

  rails_env = node[:deploy][application][:rails_env]
  deploy_to = node[:deploy][application][:deploy_to]

  Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

  # see: https://docs.chef.io/resource_execute.html
  execute "rake assets:precompile" do
    cwd "#{deploy_to}/current"
    command "bundle exec rake assets:precompile"
    environment(
      "RAILS_ENV" => rails_env,
      "SECRET_KEY_BASE" => 'c8777843099d21c53123c20624f92918844bd2ffbfe6eb52badabfe0792808089e1280d4fcc67fbb4e8e0be6a632ae087622c2745fb21e502d9b147f33a97da0'
    )
    user 'deploy'
    group 'www-data'
  end

end
