# Use Ruby 3.3.5 slim image as base
FROM ruby:3.3.5-slim

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Install system dependencies including Node.js
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    git \
    imagemagick \
    libmagickwand-dev \
    pkg-config \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle config --global frozen 1 && \
    bundle config --global jobs 4 && \
    bundle install --without development test

# Copy the application code
COPY . .

# Set a temporary secret key base for asset precompilation
ENV SECRET_KEY_BASE=temporary_key_for_precompilation

# Precompile assets
RUN bundle exec rails assets:precompile

# Create a non-root user
RUN useradd -m -u 1000 app && chown -R app:app /app
USER app

# Expose port
EXPOSE 3000

# Start the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
