class Friendship < ApplicationRecord
  # Extensions
  extend Enumerize

  # Enumerize
  enumerize :status, in: %i[pending accepted declined blocked], default: :pending

  # Validations
  validates :requester_id, presence: true
  validates :receiver_id, presence: true
  validates :requester_id, uniqueness: { scope: :receiver_id }
  validate :not_self_referential
  validate :no_reverse_active_friendship, on: :create

  # Associations
  belongs_to :requester, class_name: "User"
  belongs_to :receiver, class_name: "User"

  # Callbacks

  # Scopes
  self.status.values.each do |status_value|
    scope status_value, -> { where(status: status_value) }
  end
  scope :between, ->(user_a, user_b) {
    where(
      "(requester_id = ? AND receiver_id = ?) OR (requester_id = ? AND receiver_id = ?)",
      user_a.id, user_b.id, user_b.id, user_a.id
    )
  }
  scope :active, -> { where(status: %w[pending accepted]) }

  # Public

  # Private
  private

  def not_self_referential
    return unless requester_id.present? && receiver_id.present?

    errors.add(:base, :self_referential) if requester_id == receiver_id
  end

  def no_reverse_active_friendship
    return unless requester_id.present? && receiver_id.present?

    reverse_exists = Friendship.active.exists?(requester_id: receiver_id, receiver_id: requester_id)
    errors.add(:base, :reverse_active_friendship) if reverse_exists
  end
end
