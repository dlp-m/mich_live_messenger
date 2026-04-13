class User < ApplicationRecord
  # Extensions
  extend Enumerize
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enumerize
  enumerize :status, in: %i[available away busy], default: :available, i18n_scope: "enumerize.user.status"

  # Validations
  validates :username, presence: true
  validates :status, presence: true
  validates :personal_message, length: { maximum: 129 }, allow_blank: true

  # Associations
  has_one_attached :avatar
  has_many :sent_friendships, class_name: "Friendship", foreign_key: :requester_id, dependent: :destroy, inverse_of: :requester
  has_many :received_friendships, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy, inverse_of: :receiver

  # Callbacks

  # Scopes

  # Supports

  # Public
  def friends
    friend_ids = accepted_sent_ids + accepted_received_ids
    User.where(id: friend_ids)
  end

  def pending_sent
    sent_friendships.pending
  end

  def pending_received
    received_friendships.pending
  end

  def friendship_with(other_user)
    Friendship.between(self, other_user).first
  end

  def friend?(other_user)
    Friendship.between(self, other_user).accepted.exists?
  end

  # Protected

  # Private
  private

  def accepted_sent_ids
    sent_friendships.accepted.pluck(:receiver_id)
  end

  def accepted_received_ids
    received_friendships.accepted.pluck(:requester_id)
  end
end
