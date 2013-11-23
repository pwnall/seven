source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '>= 4.0.1'

gem 'mysql2', '>= 0.3.14'

# TODO(pwnall): remove this and switch to the Rails 4 security model.
gem 'protected_attributes'

# Core.
gem 'authpwn_rails', '>= 0.14.0'
gem 'dynamic_form', '>= 1.1.4'
gem 'markdpwn', '>= 0.1.7'
gem 'nokogiri', '>= 1.6.0'
gem 'paperclip', '>= 3.5.2'
gem 'paperclip_database', '>= 2.2.1',
    git: 'https://github.com/pwnall/paperclip_database.git',
    ref: 'contents_style'

gem 'rack-noie', '>= 1.0', require: 'noie'
gem 'rmagick', '>= 2.13.2'
gem 'validates_timeliness', '>= 3.0.14'

# Background processing.
gem 'daemonz', '>= 0.3.9'
gem 'daemons'  # Required by delayed_job.
gem 'delayed_job', '>= 4.0.0'
gem 'delayed_job_active_record', '>= 4.0.0'  # Required by delayed_job.

# PDF cover sheets.
gem 'prawn', '~> 0.12.0'

# Instant feedback.
gem 'exec_sandbox', '>= 0.2.3'
gem 'pdf-reader', '>= 1.3.0'
gem 'zip', '>= 2.0.2'

# Gravatar fall-back avatars.
gem 'gravatar-ultimate', '>= 1.0.3'

# MIT WebSIS student lookup.
gem 'mit_stalker', '>= 1.0.6'

# Report production exceptions.
gem 'exception_notification', '>= 4.0.0'

# UI
gem 'best_in_place', '>= 2.1.0',
                     git: 'https://github.com/bernat/best_in_place.git'

# Assets.
gem 'sass-rails', '>= 4.0.0'
gem 'pwnstyles_rails', '>= 0.1.31'
#gem 'pwnstyles_rails', '>= 0.1.31', path: '../pwnstyles_rails'
gem 'jquery-rails', '>= 3.0.4'
gem 'jquery-ui-rails', '>= 4.0.5'
gem 'coffee-rails', '>= 4.0.1'
gem 'uglifier', '>= 2.3.1'
gem 'therubyracer', '>= 0.12.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.5'

# Don't log BLOB values (file attachments).
gem 'trim_blobs'

group :development, :test do
  gem 'rspec-rails', '>= 2.14.0'
  gem 'thin', '>= 1.6.1'
  gem 'webrat', '>= 0.7.3'
end

group :development do
  gem 'annotate', '>= 2.6.0.beta1',
                  git: 'https://github.com/ctran/annotate_models.git'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'debugger'
  gem 'railroady', '>= 1.0.6'
end

group :production do
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
