class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: %i[accept decline destroy]

  def index
    render json: {
      friends: current_user.friends.as_json(only: %i[id username email]),
      pending_received: current_user.pending_received.as_json(
        only: %i[id status created_at],
        include: { requester: { only: %i[id username email] } }
      ),
      pending_sent: current_user.pending_sent.as_json(
        only: %i[id status created_at],
        include: { receiver: { only: %i[id username email] } }
      )
    }
  end

  def create
    authorize! Friendship, with: FriendshipPolicy

    result = Friendships::CreateService.call(
      requester: current_user,
      email: params.require(:email)
    )

    if result.success?
      render json: result.friendship.as_json(only: %i[id status created_at]), status: :created
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end

  def accept
    authorize! @friendship, to: :accept?, with: FriendshipPolicy

    if @friendship.update(status: :accepted)
      render json: @friendship.as_json(only: %i[id status updated_at])
    else
      render json: { error: @friendship.errors.full_messages.first }, status: :unprocessable_entity
    end
  end

  def decline
    authorize! @friendship, to: :decline?, with: FriendshipPolicy

    if @friendship.update(status: :declined)
      render json: @friendship.as_json(only: %i[id status updated_at])
    else
      render json: { error: @friendship.errors.full_messages.first }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! @friendship, with: FriendshipPolicy

    @friendship.destroy!
    head :no_content
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
