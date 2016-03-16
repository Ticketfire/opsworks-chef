# assumes only one app deployed
env = node[:deploy].values.first['environment']
path = node[:deploy].values.first['current_path']

node[:deploy].each do |application, deploy|

  rails_env = env["RAILS_ENV"]
  secret_key_base = env["SECRET_KEY_BASE"]
  Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

  # see: https://docs.chef.io/resource_execute.html
  execute "rake assets:precompile" do
    cwd path
    command "bundle exec rake assets:precompile"
    environment(
      "RAILS_ENV" => rails_env,
      "SECRET_KEY_BASE" => secret_key_base
    )
    user 'deploy'
    group 'www-data'
  end

end
