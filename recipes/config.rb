template "/tmp/cwlogs.cfg" do
  cookbook "opsworks-chef"
  source "cwlogs.cfg.erb"
  owner "root"
  group "root"
  mode 0644
end
