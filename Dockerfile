FROM ruby:3.1.4

RUN apt-get update -qq && apt-get install -y build-essential nano

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

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
