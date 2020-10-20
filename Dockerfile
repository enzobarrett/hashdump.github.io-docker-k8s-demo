# start with barebones filesystem with ruby
FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# outputs static html to /usr/src/app/_site
RUN jekyll build

# start from new container, saving the previous
FROM httpd:2.4

# copy static html to new container, deleting previous step
COPY --from=0 /usr/src/app/_site /usr/local/apache2/htdocs/
