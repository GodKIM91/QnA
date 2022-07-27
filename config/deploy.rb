# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

set :application, "qna"
set :repo_url, "git@github.com:GodKIM91/QnA.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"

# Default value for :pty is false
set :pty, false

# Default value for keep_releases is 5
# set :keep_releases, 5

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# unicorn restart
after 'deploy:publishing', 'unicorn:restart'

# Set custom path for RVM, cause cap try to find it /home/deployer/.rvm/bin/rvm by default
set :rvm_custom_path, '/usr/share/rvm'
