#!/bin/bash
bundle install
bundle exec rake db:migrate

/bin/sh -c "exec ${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server --host 0.0.0.0 --without-connection-token ¥"${@}¥"" --