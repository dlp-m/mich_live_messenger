class Users::CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def update
    authorize! current_user, to: :update?, with: UserPolicy
    if current_user.update(current_user_params)
      head :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def current_user_params
    params.require(:user).permit(:status, :personal_message)
  end
end
