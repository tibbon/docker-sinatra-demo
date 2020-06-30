# This is your base image. Images are built on other images
# This one comes from here: 
# https://github.com/docker-library/ruby/blob/8e49e25b591d4cfa6324b6dada4f16629a1e51ce/2.7/alpine3.12/Dockerfile
# If you haven't used Alpine, it's a tiny distribution that comes with almost nothing (not even curl) to start
FROM ruby:2.7.1-alpine3.12

MAINTAINER David Fisher <tibbon@gmail.com>

# You could try commenting out this one instead and commenting the above
# This is a slimmed down Debian distribution. Small images are good images
# FROM 2.7.1-slim-buster

# This is how you set an arg for use in this file
# I think you can pass them in an override them from the cli at runtime
ARG YOUR_APP_ROOT=/app

# Packages for below
ARG BUILD_PACKAGES="build-base gcc libstdc++ libssl1.1 libcrypto1.1 openssl-dev"

# Updates your stuff and installs packages you might want
# `RUN` commands are essentially run at the bash prompt
# Each one is a new login and loses your current directory
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --update --no-cache $BUILD_PACKAGES

RUN find / -name ssl

# Copies everything from your current directory where this Dockerfile is to /app
# The main.rb file should get copied in for example!
COPY . $YOUR_APP_ROOT/

# Sets your main working directory where commands are run from
WORKDIR $YOUR_APP_ROOT

#### This is just stuff for installing your gemfile
# ENV are set in your bash environment, and interpolate just like `make` or `bash` would do
ENV BUNDLER_VERSION 2.1.4
ENV LANG en_US.UTF-8
ENV RACK_ENV production

# The opts is because openssl is stupid
RUN gem update && \
  gem install bundler:${BUNDLER_VERSION} && \
  bundle config --global frozen 1 && \
  bundle install --jobs 4 --retry 3 && \
  bundle clean --force

# Here's the port that's exposed when running this

# This is the default command run with you execute this Dockerfile
# Can also run something else with `docker run -it image_name /bin/bash`

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
EXPOSE 4567
