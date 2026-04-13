require "rails_helper"

RSpec.describe Friendship, type: :model do
  let(:alice) { Fabricate(:user) }
  let(:bob) { Fabricate(:user) }
  let(:charlie) { Fabricate(:user) }
  let(:dave) { Fabricate(:user) }

  subject(:friendship) { Fabricate.build(:friendship, requester: alice, receiver: bob) }

  # --- Validations ---

  describe "validations" do
    it "is valid with correct attributes" do
      expect(friendship).to be_valid
    end

    it "is invalid when requester is the same as receiver" do
      friendship.receiver = alice
      expect(friendship).not_to be_valid
      expect(friendship.errors[:base]).to include(I18n.t("activerecord.errors.models.friendship.self_referential"))
    end

    it "is invalid when the same (requester, receiver) pair already exists" do
      Fabricate(:friendship, requester: alice, receiver: bob)
      expect(friendship).not_to be_valid
      expect(friendship.errors[:requester_id]).not_to be_empty
    end

    it "is invalid when the reverse pair exists in pending status" do
      Fabricate(:friendship, requester: bob, receiver: alice, status: :pending)
      expect(friendship).not_to be_valid
      expect(friendship.errors[:base]).to include(I18n.t("activerecord.errors.models.friendship.reverse_active_friendship"))
    end

    it "is invalid when the reverse pair exists in accepted status" do
      Fabricate(:friendship, requester: bob, receiver: alice, status: :accepted)
      expect(friendship).not_to be_valid
      expect(friendship.errors[:base]).to include(I18n.t("activerecord.errors.models.friendship.reverse_active_friendship"))
    end

    it "is valid when the reverse pair exists only in declined status" do
      Fabricate(:friendship, requester: bob, receiver: alice, status: :declined)
      expect(friendship).to be_valid
    end
  end

  # --- Enumerize ---

  describe "status enumerize" do
    it "defaults to pending" do
      expect(friendship.status.to_s).to eq("pending")
    end

    it "exposes all expected values" do
      expect(Friendship.status.values).to eq(%w[pending accepted declined blocked])
    end

    it "responds to status predicates" do
      friendship.status = :accepted
      expect(friendship.status).to be_accepted
    end
  end

  # --- Scopes ---

  describe "scopes" do
    let!(:pending_f)  { Fabricate(:friendship, requester: alice, receiver: bob,     status: :pending) }
    let!(:accepted_f) { Fabricate(:friendship, requester: alice, receiver: charlie,  status: :accepted) }
    let!(:declined_f) { Fabricate(:friendship, requester: alice, receiver: dave,     status: :declined) }
    let!(:blocked_f)  { Fabricate(:blocked_friendship, requester: charlie, receiver: dave) }

    describe ".pending" do
      it "returns only pending friendships" do
        expect(Friendship.pending).to include(pending_f)
        expect(Friendship.pending).not_to include(accepted_f, declined_f, blocked_f)
      end
    end

    describe ".accepted" do
      it "returns only accepted friendships" do
        expect(Friendship.accepted).to include(accepted_f)
        expect(Friendship.accepted).not_to include(pending_f, declined_f, blocked_f)
      end
    end

    describe ".declined" do
      it "returns only declined friendships" do
        expect(Friendship.declined).to include(declined_f)
        expect(Friendship.declined).not_to include(pending_f, accepted_f, blocked_f)
      end
    end

    describe ".blocked" do
      it "returns only blocked friendships" do
        expect(Friendship.blocked).to include(blocked_f)
        expect(Friendship.blocked).not_to include(pending_f, accepted_f, declined_f)
      end
    end

    describe ".active" do
      it "returns pending and accepted friendships" do
        expect(Friendship.active).to include(pending_f, accepted_f)
        expect(Friendship.active).not_to include(declined_f, blocked_f)
      end
    end

    describe ".between" do
      it "finds the friendship when called in requester→receiver order" do
        expect(Friendship.between(alice, bob)).to include(pending_f)
      end

      it "finds the friendship when called in receiver→requester order" do
        expect(Friendship.between(bob, alice)).to include(pending_f)
      end

      it "does not return unrelated friendships" do
        expect(Friendship.between(bob, charlie)).to be_empty
      end
    end
  end
end
