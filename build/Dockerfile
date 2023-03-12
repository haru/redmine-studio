FROM gitpod/openvscode-server:latest
LABEL maintainer="haru.ii.a9i1e@gmail.com"
ARG REDMINE_VER
RUN echo REDMINE_VER=${REDMINE_VER}
ARG RUBY_VER
RUN echo RUBY_VER=${RUBY_VER}

ARG http_proxy
ENV http_proxy ${http_proxy}
ARG https_proxy
ENV https_proxy ${http_proxy}
ARG no_proxy
ENV no_proxy ${no_proxy}

USER root
RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y sqlite3 libsqlite3-dev build-essential ssh  libssl-dev zlib1g-dev && apt-get clean

RUN git clone --depth=1 https://github.com/rbenv/ruby-build && PREFIX=/usr/local ./ruby-build/install.sh && rm -rf ruby-build
RUN ruby-build ${RUBY_VER:-3.0.0} /usr/local
RUN gem install bundler solargraph ruby-debug-ide
RUN mkdir -p /home/workspace/.local/share
RUN chown -R openvscode-server /home/workspace/.local/share
USER openvscode-server

RUN curl -o /tmp/redmine.tgz https://www.redmine.org/releases/redmine-${REDMINE_VER:-5.0.5}.tar.gz
WORKDIR /home/workspace

RUN tar xvfz /tmp/redmine.tgz
RUN mv redmine-* redmine
COPY database.yml redmine/config/
ENV RAILS_ENV development
WORKDIR /home/workspace/redmine

RUN echo "gem 'ruby-debug-ide'" >> Gemfile
RUN echo "gem 'debase'" >> Gemfile
RUN echo "gem 'rufo'" >> Gemfile
RUN bundle config set --local path 'vendor/bundle'
RUN bundle install
RUN mkdir db/data
RUN bundle exec rake db:migrate
RUN mkdir -p .vscode
COPY launch.json .vscode/
RUN sudo chown openvscode-server .vscode/launch.json

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
        donjayamanne.git-extension-pack \
        # From filesystem, .vsix that we downloaded (using bash wildcard '*')
        "${tdir}"/* \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done


COPY entrypoint.sh /
ENTRYPOINT [ "/bin/bash", "-x", "/entrypoint.sh" ]