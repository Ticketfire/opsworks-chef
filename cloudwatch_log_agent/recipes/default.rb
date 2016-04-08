directory "/opt/aws/cloudwatch" do
  recursive true
end

remote_file "/opt/aws/cloudwatch/awslogs-agent-setup.py" do
  source "https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py"
  mode "0755"
end

# apache logs
template "/tmp/cwlogs_apache.cfg" do
  cookbook "cloudwatch_log_agent"
  source "cwlogs_apache.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    apache_group_name: "#{node[:opsworks][:stack][:name].gsub(' ', '-').downcase}-apache"
  })
end

execute "Install CloudWatch logs agent for apache on #{node[:opsworks][:stack][:name]}..." do
  command "/opt/aws/cloudwatch/awslogs-agent-setup.py -n -r us-east-1 -c /tmp/cwlogs_apache.cfg"
  not_if { system "pgrep -f aws-logs-agent-setup" }
end

# rails logs
node[:deploy].each do |application, deploy|

  application_name = node[:deploy][application][:application].gsub(' ', '_')
  rails_env = node[:deploy][application][:rails_env]
  deploy_to = node[:deploy][application][:deploy_to]
  rails_group_name = "#{node[:opsworks][:stack][:name].gsub(' ', '_').downcase}-#{application_name}-rails-#{rails_env}"
  log_file = "#{deploy_to}/shared/log/#{rails_env}.log"

  Chef::Log.info("Installing logs agent for #{application_name} in #{rails_env}...")

  template "/tmp/cwlogs_#{application_name}.cfg" do
    cookbook "cloudwatch_log_agent"
    source "cwlogs.cfg.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      log_file: log_file,
      rails_group_name: rails_group_name
    })
  end

  execute "Install CloudWatch Logs agent for rails application #{application_name}" do
    command "/opt/aws/cloudwatch/awslogs-agent-setup.py -n -r us-east-1 -c /tmp/cwlogs_#{application_name}.cfg"
    not_if { system "pgrep -f aws-logs-agent-setup" }
  end

end
