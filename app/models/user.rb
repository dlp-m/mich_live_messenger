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
  # Callbacks
  # Scopes
  # Supports
  # Public
  # Protected
  # Private
end
