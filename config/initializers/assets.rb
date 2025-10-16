# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add app/javascript to asset paths so importmap can serve from there
Rails.application.config.assets.paths << Rails.root.join('app/javascript')
