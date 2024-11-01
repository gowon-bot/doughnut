FROM ruby:latest

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3333

CMD ["ruby", "server.rb", "-o", "0.0.0.0"]
