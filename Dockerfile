# Dockerfile for a Rails application using Nginx and Unicorn

# Select ubuntu as the base image
FROM ruby:2.2.0

# nodejs
RUN apt-get update -q
RUN apt-get install -qy nodejs
RUN apt-get install -qy postgresql-9.4
RUN apt-get install -qy libpq-dev

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
RUN npm install update

# Add rails project to project directory
ADD ./ /rails

# set WORKDIR
WORKDIR /rails

# Generate key base
RUN bundle exec rake secret >> key_base
RUN RAILS_ENV=production bundle exec rake assets:clobber
RUN RAILS_ENV=production bundle exec rake assets:precompile

CMD ["bundle", "exec", "unicorn_rails", "-E", "production"]

# Publish port 80
EXPOSE 8080
