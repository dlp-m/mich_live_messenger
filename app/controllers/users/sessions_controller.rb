class Users::SessionsController < Devise::SessionsController
  layout "application"

  def create
    super do |user|
      requested = params.dig(:user, :status)&.to_sym
      if user.persisted? && User::SELECTABLE_STATUSES.include?(requested)
        user.update_column(:status, requested)
      end
    end
  end

  def destroy
    current_user&.update_column(:status, :offline)
    super
  end
end
