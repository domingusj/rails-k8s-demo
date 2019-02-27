FROM ruby:2.5

ARG bundle_without=""
ENV BUNDLE_WITHOUT ${bundle_without}

ARG rails_env="development"
ENV RAILS_ENV ${rails_env}

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN gem install bundler -v "~>2.0"

RUN mkdir /opt/app
WORKDIR /opt/app

COPY Gemfile /opt/app/Gemfile
COPY Gemfile.lock /opt/app/Gemfile.lock

RUN bundle install

COPY . /opt/app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
