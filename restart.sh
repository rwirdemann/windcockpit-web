#!/bin/sh

cd /var/www/windcockpit/code
git pull
bundle install --deployment --without development test
bundle exec rake assets:precompile db:migrate RAILS_ENV=production
passenger-config restart-app $(pwd)