require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { Fabricate.build(:user) }

  # --- Validations ---

  describe "validations" do
    it "is valid with all required attributes" do
      expect(user).to be_valid
    end

    it "is invalid without username" do
      user.username = ""
      expect(user).not_to be_valid
      expect(user.errors[:username]).not_to be_empty
    end

    it "is invalid without email" do
      user.email = ""
      expect(user).not_to be_valid
    end

    it "is invalid with a duplicate email" do
      Fabricate(:user, email: "taken@example.com")
      user.email = "taken@example.com"
      expect(user).not_to be_valid
      expect(user.errors[:email]).not_to be_empty
    end

    it "is invalid with a too short password" do
      user.password = "short"
      expect(user).not_to be_valid
    end

    it "is invalid when status is forced to nil" do
      user.write_attribute(:status, nil)
      expect(user).not_to be_valid
      expect(user.errors[:status]).not_to be_empty
    end

    it "is invalid when personal_message exceeds 129 characters" do
      user.personal_message = "a" * 130
      expect(user).not_to be_valid
    end

    it "is valid with personal_message at exactly 129 characters" do
      user.personal_message = "a" * 129
      expect(user).to be_valid
    end
  end

  # --- Enumerize ---

  describe "status enum" do
    it "exposes the three expected values" do
      expect(User.status.values).to eq(%w[available away busy])
    end

    it "defaults to available" do
      expect(user.status.to_s).to eq("available")
    end

    it "responds to available? predicate" do
      user.status = :available
      expect(user.status).to be_available
    end

    it "responds to away? predicate" do
      user.status = :away
      expect(user.status).to be_away
    end

    it "responds to busy? predicate" do
      user.status = :busy
      expect(user.status).to be_busy
    end

    it "is invalid with an unknown status value" do
      user.write_attribute(:status, "invisible")
      expect(user).not_to be_valid
    end
  end
end
