class Users::StatusesController < ApplicationController
  before_action :authenticate_user!

  def update
    if User.status.values.include?(params[:status])
      current_user.update!(status: params[:status])
    end
    head :ok
  end
end
