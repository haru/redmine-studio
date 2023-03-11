#!/bin/bash
bundle install
bundle exec rake db:migrate
bundle exec rake redmine:plugins:migrate
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake redmine:plugins:migrate RAILS_ENV=test

/bin/sh -c "exec ${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server --host 0.0.0.0 --port 4000 --without-connection-token ¥"${@}¥"" --