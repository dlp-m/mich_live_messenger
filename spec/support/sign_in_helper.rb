module SignInHelper
  def sign_in_as(user, password: "password123")
    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: password
    click_button I18n.t("login_window.sign_in")
  end
end

RSpec.configure do |config|
  config.include SignInHelper, type: :system
end
