Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( main.js main.css z_dialog-bootstrap.js)

# For Customer
Rails.application.config.assets.precompile += %w( customer.css customer.js)

# For Admin
Rails.application.config.assets.precompile += %w( admin.css admin.js)

# For fonts
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf|woff2)\z/
