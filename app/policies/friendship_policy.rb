# frozen_string_literal: true

class FriendshipPolicy < ActionPolicy::Base
  def create?
    user.present?
  end

  def accept?
    record.receiver == user && record.status.pending?
  end

  def decline?
    record.receiver == user && record.status.pending?
  end

  def destroy?
    record.requester == user || record.receiver == user
  end

  def block?
    record.receiver == user && record.status.accepted?
  end
end
