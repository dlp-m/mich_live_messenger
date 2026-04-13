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

  # --- Friendship methods ---

  describe "friendship associations and helpers" do
    let(:alice) { Fabricate(:user) }
    let(:bob)   { Fabricate(:user) }
    let(:carol) { Fabricate(:user) }

    describe "#friends" do
      it "includes a user with whom an accepted friendship was sent" do
        Fabricate(:accepted_friendship, requester: alice, receiver: bob)
        expect(alice.friends).to include(bob)
      end

      it "includes a user with whom an accepted friendship was received" do
        Fabricate(:accepted_friendship, requester: bob, receiver: alice)
        expect(alice.friends).to include(bob)
      end

      it "excludes users with only a pending friendship" do
        Fabricate(:friendship, requester: alice, receiver: bob, status: :pending)
        expect(alice.friends).not_to include(bob)
      end

      it "returns an empty relation when no accepted friendships exist" do
        expect(alice.friends).to be_empty
      end
    end

    describe "#pending_sent" do
      it "returns pending friendships where the user is the requester" do
        f = Fabricate(:friendship, requester: alice, receiver: bob, status: :pending)
        expect(alice.pending_sent).to include(f)
      end

      it "does not include received pending friendships" do
        Fabricate(:friendship, requester: bob, receiver: alice, status: :pending)
        expect(alice.pending_sent).to be_empty
      end
    end

    describe "#pending_received" do
      it "returns pending friendships where the user is the receiver" do
        f = Fabricate(:friendship, requester: bob, receiver: alice, status: :pending)
        expect(alice.pending_received).to include(f)
      end

      it "does not include sent pending friendships" do
        Fabricate(:friendship, requester: alice, receiver: bob, status: :pending)
        expect(alice.pending_received).to be_empty
      end
    end

    describe "#friendship_with" do
      it "returns the friendship record between two users" do
        f = Fabricate(:friendship, requester: alice, receiver: bob)
        expect(alice.friendship_with(bob)).to eq(f)
      end

      it "finds the friendship regardless of direction" do
        f = Fabricate(:friendship, requester: bob, receiver: alice)
        expect(alice.friendship_with(bob)).to eq(f)
      end

      it "returns nil when no friendship exists" do
        expect(alice.friendship_with(bob)).to be_nil
      end
    end

    describe "#friend?" do
      it "returns true when an accepted friendship exists" do
        Fabricate(:accepted_friendship, requester: alice, receiver: bob)
        expect(alice.friend?(bob)).to be true
      end

      it "returns true regardless of direction" do
        Fabricate(:accepted_friendship, requester: bob, receiver: alice)
        expect(alice.friend?(bob)).to be true
      end

      it "returns false when the friendship is pending" do
        Fabricate(:friendship, requester: alice, receiver: bob, status: :pending)
        expect(alice.friend?(bob)).to be false
      end

      it "returns false when no friendship exists" do
        expect(alice.friend?(bob)).to be false
      end
    end
  end

  # --- Enumerize ---

  describe "status enum" do
    it "exposes the four expected values" do
      expect(User.status.values).to eq(%w[available away busy offline])
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
