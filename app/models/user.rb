class User < ApplicationRecord
  # Extensions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Enumerize
  # Validations
  validates :username, presence: true
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
