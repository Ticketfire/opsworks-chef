rails_env = node[:deploy][@application_name][:rails_env]
path = node[:deploy][@application_name][:current_path]

default[:cwlogs][:rails][:logfile] = path + '/log/' + rails_env + '.log'
