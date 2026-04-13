class Users::CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def update
    current_user.assign_attributes(current_user_params)
    authorize! current_user, to: :update?, with: UserPolicy
    if current_user.save
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
