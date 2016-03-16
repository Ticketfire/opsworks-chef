rails_env = deploy[:rails_env]
path = deploy[:current_path]

default[:cwlogs][:rails][:logfile] = 'srv/www/tf_api_int/shared/log/' + rails_env + '.log'
