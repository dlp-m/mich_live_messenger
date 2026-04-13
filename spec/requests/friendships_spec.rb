require "rails_helper"

RSpec.describe "Friendships", type: :request do
  let(:alice) { Fabricate(:user) }
  let(:bob)   { Fabricate(:user) }
  let(:carol) { Fabricate(:user) }

  # --- GET /friendships ---

  describe "GET /friendships" do
    context "when authenticated" do
      before { sign_in alice }

      it "returns HTTP 200" do
        get friendships_path, as: :json
        expect(response).to have_http_status(:ok)
      end

      it "returns the expected JSON keys" do
        get friendships_path, as: :json
        json = response.parsed_body
        expect(json.keys).to match_array(%w[friends pending_received pending_sent])
      end

      it "includes accepted friends" do
        Fabricate(:accepted_friendship, requester: alice, receiver: bob)
        get friendships_path, as: :json
        json = response.parsed_body
        friend_ids = json["friends"].map { |f| f["id"] }
        expect(friend_ids).to include(bob.id)
      end

      it "includes pending received requests" do
        f = Fabricate(:friendship, requester: bob, receiver: alice, status: :pending)
        get friendships_path, as: :json
        json = response.parsed_body
        ids = json["pending_received"].map { |r| r["id"] }
        expect(ids).to include(f.id)
      end

      it "includes pending sent requests" do
        f = Fabricate(:friendship, requester: alice, receiver: bob, status: :pending)
        get friendships_path, as: :json
        json = response.parsed_body
        ids = json["pending_sent"].map { |r| r["id"] }
        expect(ids).to include(f.id)
      end
    end

    context "when not authenticated" do
      it "redirects to sign in" do
        get friendships_path, as: :json
        expect(response).to have_http_status(:unauthorized).or redirect_to(new_user_session_path)
      end
    end
  end

  # --- POST /friendships ---

  describe "POST /friendships" do
    before { sign_in alice }

    context "with a valid email" do
      it "returns HTTP 201" do
        post friendships_path, params: { email: bob.email }, as: :json
        expect(response).to have_http_status(:created)
      end

      it "creates a new pending Friendship" do
        expect {
          post friendships_path, params: { email: bob.email }, as: :json
        }.to change(Friendship, :count).by(1)
      end

      it "returns the friendship with pending status" do
        post friendships_path, params: { email: bob.email }, as: :json
        expect(response.parsed_body["status"]).to eq("pending")
      end
    end

    context "with an unknown email" do
      it "returns HTTP 422" do
        post friendships_path, params: { email: "ghost@example.com" }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error message" do
        post friendships_path, params: { email: "ghost@example.com" }, as: :json
        expect(response.parsed_body["error"]).to eq(I18n.t("friendships.errors.user_not_found"))
      end
    end

    context "when a pending friendship already exists" do
      before { Fabricate(:friendship, requester: alice, receiver: bob, status: :pending) }

      it "returns HTTP 422" do
        post friendships_path, params: { email: bob.email }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # --- PATCH /friendships/:id/accept ---

  describe "PATCH /friendships/:id/accept" do
    let!(:friendship) { Fabricate(:friendship, requester: alice, receiver: bob, status: :pending) }

    context "when the receiver accepts" do
      before { sign_in bob }

      it "returns HTTP 200" do
        patch accept_friendship_path(friendship), as: :json
        expect(response).to have_http_status(:ok)
      end

      it "updates the status to accepted" do
        patch accept_friendship_path(friendship), as: :json
        expect(friendship.reload.status.to_s).to eq("accepted")
      end
    end

    context "when the requester tries to accept their own request" do
      before { sign_in alice }

      it "returns HTTP 403" do
        patch accept_friendship_path(friendship), as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when a third party tries to accept" do
      before { sign_in carol }

      it "returns HTTP 403" do
        patch accept_friendship_path(friendship), as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  # --- PATCH /friendships/:id/decline ---

  describe "PATCH /friendships/:id/decline" do
    let!(:friendship) { Fabricate(:friendship, requester: alice, receiver: bob, status: :pending) }

    context "when the receiver declines" do
      before { sign_in bob }

      it "returns HTTP 200" do
        patch decline_friendship_path(friendship), as: :json
        expect(response).to have_http_status(:ok)
      end

      it "updates the status to declined" do
        patch decline_friendship_path(friendship), as: :json
        expect(friendship.reload.status.to_s).to eq("declined")
      end
    end

    context "when the requester tries to decline" do
      before { sign_in alice }

      it "returns HTTP 403" do
        patch decline_friendship_path(friendship), as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  # --- DELETE /friendships/:id ---

  describe "DELETE /friendships/:id" do
    let!(:friendship) { Fabricate(:accepted_friendship, requester: alice, receiver: bob) }

    context "when the requester deletes" do
      before { sign_in alice }

      it "returns HTTP 204" do
        delete friendship_path(friendship), as: :json
        expect(response).to have_http_status(:no_content)
      end

      it "destroys the friendship" do
        expect {
          delete friendship_path(friendship), as: :json
        }.to change(Friendship, :count).by(-1)
      end
    end

    context "when the receiver deletes" do
      before { sign_in bob }

      it "returns HTTP 204" do
        delete friendship_path(friendship), as: :json
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when a third party tries to delete" do
      before { sign_in carol }

      it "returns HTTP 403" do
        delete friendship_path(friendship), as: :json
        expect(response).to have_http_status(:forbidden)
      end

      it "does not destroy the friendship" do
        expect {
          delete friendship_path(friendship), as: :json
        }.not_to change(Friendship, :count)
      end
    end
  end
end
