Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( erp_angular.js angular-rails-templates.js angular-route/angular-route.js angular/angular.js ng-app/app.js ng-app/controllers/home.js main.js main.css)

# For Customer
Rails.application.config.assets.precompile += %w( customer.css customer.js)

# For Admin
Rails.application.config.assets.precompile += %w( admin.css admin.js)

# For fonts
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf|woff2)\z/
