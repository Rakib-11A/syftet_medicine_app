# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w( admin.css )
Rails.application.config.assets.precompile += %w( dashboard.scss )
Rails.application.config.assets.precompile += %w( css/animatee.css )
Rails.application.config.assets.precompile += %w( css/animatee.min.css )
Rails.application.config.assets.precompile += %w( css/bootstrap-dropdownhover.css )
Rails.application.config.assets.precompile += %w( css/bootstrap-dropdownhover.min.css )
Rails.application.config.assets.precompile += %w( admin.js )
Rails.application.config.assets.precompile += %w( dashboard.js )
Rails.application.config.assets.precompile += %w( js/bootstrap-dropdownhover.js )
Rails.application.config.assets.precompile += %w( js/bootstrap-dropdownhover.min.js )
#Rails.application.config.assets.precompile += %w( ckeditor/*)
Rails.application.config.assets.precompile += %w[ckeditor/config.js]
Rails.application.config.assets.precompile += %w( jQuery.print.js )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
