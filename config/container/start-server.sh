# start-server.sh

#!/bin/bash
cd /rails
source /etc/profile.d/rvm.sh
export SECRET_KEY_BASE=$(rake secret)
bundle exec unicorn_rails -D -p 8080 -E production
nginx
