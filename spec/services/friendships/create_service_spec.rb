require "rails_helper"

RSpec.describe Friendships::CreateService, type: :model do
  let(:alice) { Fabricate(:user) }
  let(:bob)   { Fabricate(:user) }

  subject(:result) { described_class.call(requester: alice, email: bob.email) }

  # --- Happy path ---

  context "when the email belongs to another user" do
    it "returns a successful result" do
      expect(result.success?).to be true
    end

    it "creates a new Friendship" do
      expect { result }.to change(Friendship, :count).by(1)
    end

    it "sets status to pending" do
      expect(result.friendship.status.to_s).to eq("pending")
    end

    it "assigns requester and receiver correctly" do
      expect(result.friendship.requester).to eq(alice)
      expect(result.friendship.receiver).to eq(bob)
    end

    it "returns no error" do
      expect(result.error).to be_nil
    end
  end

  # --- Failure: unknown email ---

  context "when the email is not found" do
    subject(:result) { described_class.call(requester: alice, email: "nobody@example.com") }

    it "returns a failed result" do
      expect(result.success?).to be false
    end

    it "returns the appropriate error message" do
      expect(result.error).to eq(I18n.t("friendships.errors.user_not_found"))
    end

    it "does not create a Friendship" do
      expect { result }.not_to change(Friendship, :count)
    end
  end

  # --- Failure: self-request ---

  context "when the requester emails themselves" do
    subject(:result) { described_class.call(requester: alice, email: alice.email) }

    it "returns a failed result" do
      expect(result.success?).to be false
    end

    it "returns the self-reference error message" do
      expect(result.error).to eq(I18n.t("friendships.errors.self_request"))
    end

    it "does not create a Friendship" do
      expect { result }.not_to change(Friendship, :count)
    end
  end

  # --- Failure: already pending ---

  context "when a pending friendship already exists (alice → bob)" do
    before { Fabricate(:friendship, requester: alice, receiver: bob, status: :pending) }

    it "returns a failed result" do
      expect(result.success?).to be false
    end

    it "returns a duplicate error message" do
      expect(result.error).to eq(I18n.t("friendships.errors.already_exists"))
    end

    it "does not create an additional Friendship" do
      expect { result }.not_to change(Friendship, :count)
    end
  end

  context "when a pending friendship exists in the reverse direction (bob → alice)" do
    before { Fabricate(:friendship, requester: bob, receiver: alice, status: :pending) }

    it "returns a failed result" do
      expect(result.success?).to be false
    end

    it "returns a duplicate error message" do
      expect(result.error).to eq(I18n.t("friendships.errors.already_exists"))
    end
  end

  # --- Failure: already accepted ---

  context "when the friendship is already accepted" do
    before { Fabricate(:accepted_friendship, requester: alice, receiver: bob) }

    it "returns a failed result" do
      expect(result.success?).to be false
    end

    it "returns a duplicate error message" do
      expect(result.error).to eq(I18n.t("friendships.errors.already_exists"))
    end
  end

  # --- Failure: blocked ---

  context "when the friendship is blocked" do
    before { Fabricate(:blocked_friendship, requester: alice, receiver: bob) }

    it "returns a failed result" do
      expect(result.success?).to be false
    end

    it "returns the blocked error message" do
      expect(result.error).to eq(I18n.t("friendships.errors.blocked"))
    end

    it "does not create a Friendship" do
      expect { result }.not_to change(Friendship, :count)
    end
  end

  # --- Reset: declined → pending ---

  context "when a declined friendship exists (bob declined alice)" do
    let!(:declined) { Fabricate(:declined_friendship, requester: bob, receiver: alice) }

    it "returns a successful result" do
      expect(result.success?).to be true
    end

    it "does not create a new Friendship" do
      expect { result }.not_to change(Friendship, :count)
    end

    it "resets the existing friendship to pending" do
      result
      expect(declined.reload.status.to_s).to eq("pending")
    end

    it "swaps requester and receiver so alice is the new requester" do
      result
      expect(declined.reload.requester).to eq(alice)
      expect(declined.reload.receiver).to eq(bob)
    end
  end
end
