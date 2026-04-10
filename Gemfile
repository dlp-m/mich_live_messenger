source "https://rubygems.org"

# --- Core ---
gem "rails", "~> 8.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# --- Assets & Frontend ---
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "view_component"
gem "tailwindcss-rails", "~> 3.3.1"
gem "tybo", path: "/home/dlp/rails/perso/tybo"

# --- Forms & UI ---
gem "simple_form"
gem "simple_form-tailwind", "~> 0.1.1"

# --- Authorization ---
gem "action_policy", "~> 0.7.5"
# gem "bcrypt", "~> 3.1.7"

# --- Enums & i18n ---
gem "enumerize"

# --- Database & Queries ---
gem "activerecord_where_assoc"

# --- Background jobs & Caching ---
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# --- File storage ---
gem "image_processing", "~> 1.2"

# --- Deployment ---
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  # --- Debugging ---
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # --- Environment ---
  gem "dotenv-rails"

  # --- Security ---
  gem "bundler-audit", require: false
  gem "bundler-audit"
  gem "brakeman", require: false

  # --- Linting ---
  gem "rubocop-rails-omakase", require: false
  gem "erb_lint", require: false

  # --- Live reload ---
  gem "hotwire-livereload"
end

group :development do
  # --- Console & debugging ---
  gem "web-console"
  gem "annotaterb"

  # --- Linting ---
  gem "rubocop"
  gem "rubocop-rails", require: false
  gem "rubocop-performance"
end

group :test do
  # --- System tests ---
  gem "capybara"
  gem "selenium-webdriver"

  # --- Coverage ---
  gem "simplecov", require: false
end
