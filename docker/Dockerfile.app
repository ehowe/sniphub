FROM ruby:3.1-alpine

RUN apk update && apk add g++ make postgresql-dev

WORKDIR /usr/src/app

COPY backend/Gemfile /usr/src/app/Gemfile
COPY backend/Gemfile.lock /usr/src/app/Gemfile.lock
COPY docker/entrypoint.sh /

RUN bundle config --local set without development test && \
  bundle config set --global path /usr/local/share/gems && \
  bundle install --jobs 4

EXPOSE 4000
