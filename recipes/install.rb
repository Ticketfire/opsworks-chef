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

  template "/tmp/cwlogs_${application_name}.cfg" do
    cookbook "opsworks-chef"
    source "cwlogs.cfg.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      application_name: application_name,
      rails_env: rails_env
    })
  end

  execute "Install CloudWatch Logs agent for rails application ${application_name}" do
    command "/opt/aws/cloudwatch/awslogs-agent-setup.py -n -r us-east-1 -c /tmp/cwlogs_${application_name}.cfg"
    not_if { system "pgrep -f aws-logs-agent-setup" }
  end

end
