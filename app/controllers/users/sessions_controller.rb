class Users::SessionsController < Devise::SessionsController
  layout "application"

  def create
    super do |user|
      if user.persisted? && User.status.values.include?(params.dig(:user, :status))
        user.update_column(:status, params[:user][:status])
      end
    end
  end
end
