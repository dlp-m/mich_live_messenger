RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end

  config.after(:each, type: :system) do
    Capybara.reset_sessions!
  end
end
