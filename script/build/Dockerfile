FROM ubuntu:14.04

ENV BUILD_DATE 2015-11-17 # Change this to force a cache-bust and rebuild the whole image
ENV DEBIAN_FRONTEND noninteractive

# Install necessary bits for adding external sources
RUN apt-get update && apt-get install -y curl apt-transport-https

# Add external sources & keys
ADD externals.list /etc/apt/sources.list.d/externals.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6 86F44E2A EEA14886 5E5C44C6 \
 && apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A \
 && curl https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
 && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc  | apt-key add - \
 && apt-get update

# Install packages
RUN apt-get -y install build-essential git-core \
 libssl-dev libmysqlclient-dev wget imagemagick \
 curl apt-transport-https sudo nodejs \
 libpq-dev \
 ruby2.3 ruby2.3-dev \
 postgresql-9.4 postgresql-contrib-9.4 \
 redis-server ruby2.3 ruby2.3-dev

# Install rubygems
RUN gem update --system --no-ri --no-rdoc && gem install bundler --no-ri --no-rdoc

# Setup phantomjs
WORKDIR /tmp
RUN wget https://github.com/skakri/phantomjs/releases/download/2.0.1-regression-12506/ubuntu-x86_64-phantomjs \
  && mv ubuntu-x86_64-phantomjs /usr/bin/phantomjs \
  && chmod 0755 /usr/bin/phantomjs
