rails_env = deploy[:rails_env]
path = deploy[:current_path]

default[:cwlogs][:rails][:logfile] = path + '/log/' + rails_env + '.log'
