class User < ApplicationRecord
  # Constants
  SELECTABLE_STATUSES = %i[available away busy].freeze
  STATUSES = (SELECTABLE_STATUSES + [ :offline ]).freeze
  # Extensions
  extend Enumerize
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enumerize
  enumerize :status, in: STATUSES, default: :available, i18n_scope: "enumerize.user.status"

  # Validations
  validates :username, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES.map(&:to_s) }
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
    User.joins(
      "INNER JOIN friendships ON (friendships.requester_id = #{id} AND friendships.receiver_id = users.id) " \
      "OR (friendships.receiver_id = #{id} AND friendships.requester_id = users.id)"
    ).where(friendships: { status: :accepted })
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
end
