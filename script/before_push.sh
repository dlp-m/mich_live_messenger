bundle exec rspec
bundle exec rubocop --config .rubocop.yml --format simple
bundle exec brakeman
bundle exec erb_lint --config .erb-lint.yml --lint-all
bundle audit check --update