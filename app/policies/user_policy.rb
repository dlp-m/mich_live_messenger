# frozen_string_literal: true

class UserPolicy < ActionPolicy::Base
  def update?
    record == user && !setting_offline?
  end

  private

  def setting_offline?
    record.status_changed? && record.status.to_sym == :offline
  end
end
