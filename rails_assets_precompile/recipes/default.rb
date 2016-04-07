node[:deploy].each do |application, deploy|

  rails_env = node[:deploy][application][:rails_env]
  deploy_to = node[:deploy][application][:deploy_to]

  secret_key_base = env["SECRET_KEY_BASE"]
  Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

  # see: https://docs.chef.io/resource_execute.html
  execute "rake assets:precompile" do
    cwd deploy_to
    command "bundle exec rake assets:precompile"
    environment(
      "RAILS_ENV" => rails_env,
      "SECRET_KEY_BASE" => secret_key_base
    )
    user 'deploy'
    group 'www-data'
  end

end
