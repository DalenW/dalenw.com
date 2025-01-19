FROM ruby:3.3.6

ARG RAILS_ROOT=/app
ARG PACKAGES="tzdata postgresql-client bash git libvips libvips-tools libvips-dev curl"

WORKDIR $RAILS_ROOT

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y $PACKAGES

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && apt-get install -y nodejs


# copy and build the gems first, so a minor change doesn't force docker to rebuild this step

COPY Gemfile* ./
COPY Gemfile Gemfile.lock $RAILS_ROOT/
COPY .ruby-version $RAILS_ROOT/
COPY package.json $RAILS_ROOT/

RUN gem install bundler \
    && bundle config set --local path 'vendor/bundle' \
    && bundle config --global frozen 1 \
    && bundle install -j4 --retry 3

RUN npm install

# Remove folders not needed in resulting image
RUN rm -rf tmp/cache spec

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 TAILWINDCSS_INSTALL_DIR=node_modules/.bin ./bin/rails assets:precompile

CMD ["bundle", "exec", "rake", "entrypoint:init"]