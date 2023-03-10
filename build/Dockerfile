FROM gitpod/openvscode-server:latest
LABEL maintainer="haru.ii.a9i1e@gmail.com"
ARG REDMINE_VER
USER root
RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y ruby ruby-full ruby-dev sqlite3 libsqlite3-dev build-essential && apt-get clean
RUN gem install bundler
RUN curl -o /tmp/redmine.tgz https://www.redmine.org/releases/redmine-${REDMINE_VER}.tar.gz
WORKDIR /home/workspace
USER openvscode-server
RUN tar xvfz /tmp/redmine.tgz
RUN mv redmine-* redmine
COPY database.yml redmine/config/
ENV RAILS_ENV development
WORKDIR /home/workspace/redmine
RUN bundle install --path vendor/bundle
RUN bundle exec rake db:migrate

