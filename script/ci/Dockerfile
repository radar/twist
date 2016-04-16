FROM twist/ci

ENV RAILS_ENV test

run rsync -v -a /source/ /build/ --exclude log --exclude tmp --exclude repos --exclude public/system --exclude public/images

COPY .bundler-cache /cache/bundler

RUN cd /build \
  && (bundle check --path /cache/bundler || bundle install --deployment --path /cache/bundler -j 8) \
  && bundle exec rake db:create \
  && bundle exec rake db:test:prepare \
  && git submodule update --init
