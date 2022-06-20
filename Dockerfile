FROM ruby:3.0-buster

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential nodejs yarn postgresql-client libpq-dev imagemagick vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV APP /app

ARG LOCAL_USER_ID
ENV LOCAL_USER_ID $LOCAL_USER_ID

RUN mkdir $APP
WORKDIR $APP
COPY . $APP

RUN gem install bundler \
  && bundle install
