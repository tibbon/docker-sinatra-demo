# This is your base image. Images are built on other images
# This one comes from here: 
# https://github.com/docker-library/ruby/blob/8e49e25b591d4cfa6324b6dada4f16629a1e51ce/2.7/alpine3.12/Dockerfile
# If you haven't used Alpine, it's a tiny distribution that comes with almost nothing (not even curl) to start
FROM ruby:2.7.1-alpine3.12

LABEL maintainer David Fisher <tibbon@gmail.com>

# You could try commenting out this one instead and commenting the above
# This is a slimmed down Debian distribution. Small images are good images
# FROM 2.7.1-slim-buster

# This is how you set an arg for use in this file
# I think you can pass them in an override them from the cli at runtime
ARG APP_ROOT=/app

# Updates and installs packages you need for running Ruby/Sinatra
# Each one is a new login and loses your current directory
ARG BUILD_PACKAGES="build-base gcc libstdc++ libssl1.1 libcrypto1.1 openssl-dev"

# `RUN` commands are essentially run at the bash prompt
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --update --no-cache $BUILD_PACKAGES

#### This is just stuff for installing your gemfile
# ENV are set in your bash environment, and interpolate just like `make` or `bash` would do
ENV BUNDLER_VERSION 2.1.4
ENV LANG en_US.UTF-8
ENV RACK_ENV production

# Copies over just the Gemfile. Not everything yet, because it caches layers better this way
ADD Gemfile* $APP_ROOT/
RUN gem update && \
  ls -al && \
  gem install bundler:${BUNDLER_VERSION} && \
  bundle config set without 'development test' && \
  bundle config --global frozen 1

# Separate layer because it's faster with caching
RUN cd $APP_ROOT && \
  bundle install --jobs 4 --retry 3

# Copies everything from your current directory where this Dockerfile is to /app
# The main.rb file should get copied in for example!
COPY . $APP_ROOT/

# Sets your main working directory where commands are run from
WORKDIR $APP_ROOT

# Here's the port that's exposed when running this
EXPOSE 4567

# This is the default command run with you execute this Dockerfile
# Can also run something else with `docker run -it image_name /bin/bash`
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
