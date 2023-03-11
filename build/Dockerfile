FROM gitpod/openvscode-server:latest
LABEL maintainer="haru.ii.a9i1e@gmail.com"
ARG REDMINE_VER
RUN echo aaa
USER root
RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y ruby ruby-full ruby-dev sqlite3 libsqlite3-dev build-essential ssh && apt-get clean
RUN gem install bundler solargraph
RUN curl -o /tmp/redmine.tgz https://www.redmine.org/releases/redmine-${REDMINE_VER}.tar.gz
WORKDIR /home/workspace
USER openvscode-server
RUN tar xvfz /tmp/redmine.tgz
RUN mv redmine-* redmine
COPY database.yml redmine/config/
ENV RAILS_ENV development
WORKDIR /home/workspace/redmine
RUN echo "gem 'ruby-debug-ide'" >> Gemfile
RUN echo "gem 'debase'" >> Gemfile
RUN echo "gem 'rufo'" >> Gemfile
RUN bundle install --path vendor/bundle
RUN mkdir db/data
RUN bundle exec rake db:migrate
RUN mkdir -p .vscode
COPY launch.json .vscode/

ENV OPENVSCODE_SERVER_ROOT="/home/.openvscode-server"
ENV OPENVSCODE="${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server"


SHELL ["/bin/bash", "-c"]
RUN \
    # Direct download links to external .vsix not available on https://open-vsx.org/
    # The two links here are just used as example, they are actually available on https://open-vsx.org/
    urls=(\
        https://github.com/rust-lang/rust-analyzer/releases/download/2022-12-26/rust-analyzer-linux-x64.vsix \
        https://github.com/VSCodeVim/Vim/releases/download/v1.24.3/vim-1.24.3.vsix \
    )\
    # Create a tmp dir for downloading
    && tdir=/tmp/exts && mkdir -p "${tdir}" && cd "${tdir}" \
    # Download via wget from $urls array.
    && wget "${urls[@]}" && \
    # List the extensions in this array
    exts=(\
        # From https://open-vsx.org/ registry directly
        gitpod.gitpod-theme \
        rebornix.Ruby \
        andrewmcodes.rails-extension-power-pack \
        # From filesystem, .vsix that we downloaded (using bash wildcard '*')
        "${tdir}"/* \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done


COPY entrypoint.sh /
ENTRYPOINT [ "/bin/bash", "-x", "/entrypoint.sh" ]