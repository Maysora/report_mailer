ARG RUBY_VERSION=3.4.4
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config libyaml-dev

RUN apt-get update -qq && apt-get install -y nano

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_23.x | bash - && apt-get install -y nodejs

# yarn
RUN npm install --global yarn

ENV BUNDLE_PATH=/gemcache
RUN echo 'gem: --no-document' > ~/.gemrc
RUN gem install bundler -v 2.4.19

RUN gem install foreman

ENV APP_HOME=/my_app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
