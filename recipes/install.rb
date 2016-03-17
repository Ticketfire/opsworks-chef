directory "/opt/aws/cloudwatch" do
  recursive true
end

remote_file "/opt/aws/cloudwatch/awslogs-agent-setup.py" do
  source "https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py"
  mode "0755"
end

node[:deploy].each do |application, deploy|

  application_name = node[:deploy][application][:application].gsub(' ', '_')
  rails_env = node[:deploy][application][:rails_env]
  deploy_to = node[:deploy][application][:deploy_to]
  group_name = node[:opsworks][:stack][:name].gsub(' ', '_') + '_rails_' + rails_env
  log_file = "#{deploy_to}/shared/log/#{rails_env}.log"

  Chef::Log.info("Installing logs agent for #{application_name} in #{rails_env}...")

  template "/tmp/cwlogs_#{group_name}.cfg" do
    cookbook "opsworks-chef"
    source "cwlogs.cfg.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      log_file: log_file,
      group_name: group_name
    })
  end

  execute "Install CloudWatch Logs agent for rails application #{group_name}" do
    command "/opt/aws/cloudwatch/awslogs-agent-setup.py -n -r us-east-1 -c /tmp/cwlogs_#{group_name}.cfg"
    not_if { system "pgrep -f aws-logs-agent-setup" }
  end

end
