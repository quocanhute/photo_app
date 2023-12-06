# Dockerfile

# Use the official Ruby image
FROM ruby:3.0.0

# Set the working directory
WORKDIR /myapp

# Install dependencies
RUN apt-get update -qq
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler
RUN bundle install

# Copy the application files to the container
COPY . .

# Expose port 3000
EXPOSE 3000
