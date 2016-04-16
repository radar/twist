FROM twist/ci

ENV RAILS_ENV test

run rsync -v -a /source/ /build/ --exclude log --exclude tmp --exclude repos --exclude public/system --exclude public/images

RUN sudo service postgresql start
RUN sudo service redis-server start

RUN cd /build &&
  (bundle check --path /cache/bundler || bundle install --deployment --path /cache/bundler -j 8) &&
  bundle exec rake db:create &&
  bundle exec rake db:test:prepare
  git submodule update --init
