#!/bin/sh

cd /usr/src/app

bundle exec rake db:migrate
bundle exec puma -p 4000
