source :rubygems
ruby '1.9.3'

gem 'rails', '>= 3.2.9'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2', '>= 0.3.11'

gem 'json', '>= 1.5.4'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Core.
gem 'authpwn_rails', '>= 0.13.1'
gem 'dynamic_form', '>= 1.1.4'
gem 'markdpwn', '>= 0.1.5'
gem 'nokogiri', '>= 1.5.0'
gem 'paperclip', :git => 'git://github.com/patshaughnessy/paperclip.git',
                 :ref => '729848221b19c3791a35c80fe9803f4c1b6dd7d9'
gem 'rack-noie', :require => 'noie.rb',
                 :git => 'git://github.com/juliocesar/rack-noie.git'
gem 'rmagick', '>= 2.13.1'
gem 'validates_timeliness', '>= 3.0.11'

# Background processing.
gem 'daemonz', '>= 0.3.9'
gem 'daemons'  # Required by delayed_job.
gem 'delayed_job', '>= 3.0.4'
gem 'delayed_job_active_record', '>= 0.3.3'  # Required by delayed_job.

# PDF cover sheets.
gem 'prawn', '~> 0.12.0'

# Instant feedback.
gem 'exec_sandbox', '>= 0.2.3'
gem 'pdf-reader', '>= 1.2.0'
gem 'zip', '>= 2.0.2'

# Gravatar fall-back avatars.
gem 'gravatar-ultimate', '>= 1.0.3'

# MIT WebSIS student lookup.
gem 'mit_stalker', '>= 1.0.4'

# MIT Stellar integration.
gem 'stellar', '>= 0.3.1'

# Web
gem 'best_in_place'

group :assets do
  gem 'sass-rails', '>= 3.2.5'
  gem 'pwnstyles_rails', '>= 0.1.29'
  # gem 'pwnstyles_rails', '>= 0.1.28', path: '../pwnstyles_rails'

  gem 'jquery-rails', '>= 2.1.4'
  gem 'coffee-rails', '>= 3.2.2'
  gem 'uglifier', '>= 1.3.0'

  gem 'therubyracer', '>= 0.11.0'
  gem 'libv8', '>= 3.11.8.4'
end

group :development, :test do
  gem 'rspec-rails', '>= 2.11.0'
  gem 'thin', '>= 1.4.1'
  gem 'webrat', '>= 0.7.3'
end

group :development do
  gem 'annotate', '>= 2.6.0.beta1',
                  :git => 'git://github.com/ctran/annotate_models.git'
  gem 'railroady', '>= 1.0.6'
end
