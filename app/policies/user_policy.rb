# frozen_string_literal: true

class UserPolicy < ActionPolicy::Base
  def update?
    record == user
  end
end
