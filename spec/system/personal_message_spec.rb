require "rails_helper"

RSpec.describe "Personal message inline edit", type: :system do
  let(:user) { Fabricate(:user, personal_message: nil) }

  before { sign_in_as(user) }

  it "shows the placeholder when personal message is blank" do
    expect(page).to have_content("Cliquez ici pour ajouter un message")
  end

  it "clears the placeholder on focus" do
    el = find("[data-controller='personal-message']")
    el.click
    expect(el.text).to eq("")
  end

  it "saves a new personal message on Enter" do
    find("[data-controller='personal-message']").click
    find("[data-controller='personal-message']").send_keys("Hello world !", :return)

    expect(page).to have_selector("[data-controller='personal-message'][data-saved='true']")
    expect(page).to have_content("Hello world !")
    expect(user.reload.personal_message).to eq("Hello world !")
  end

  it "saves on blur" do
    el = find("[data-controller='personal-message']")
    el.click
    el.send_keys("En train de coder")
    execute_script("document.querySelector(\"[data-controller='personal-message']\").blur()")

    expect(page).to have_selector("[data-controller='personal-message'][data-saved='true']")
    expect(user.reload.personal_message).to eq("En train de coder")
  end

  it "cancels on Escape and restores original text" do
    find("[data-controller='personal-message']").click
    find("[data-controller='personal-message']").send_keys("texte annulé", :escape)

    expect(page).to have_content("Cliquez ici pour ajouter un message")
    expect(user.reload.personal_message).to be_blank
  end

  context "with an existing personal message" do
    let(:user) { Fabricate(:user, personal_message: "Message existant") }

    it "shows the existing message" do
      expect(page).to have_content("Message existant")
    end

    it "restores the original message on Escape" do
      find("[data-controller='personal-message']").click
      find("[data-controller='personal-message']").send_keys(" modifié", :escape)

      expect(page).to have_content("Message existant")
    end

    it "clears the message when saved empty" do
      el = find("[data-controller='personal-message']")
      el.click
      execute_script("arguments[0].textContent = ''", el)
      el.send_keys(:return)

      expect(page).to have_selector("[data-controller='personal-message'][data-saved='true']")
      expect(page).to have_content("Cliquez ici pour ajouter un message")
      expect(user.reload.personal_message).to be_blank
    end
  end
end
