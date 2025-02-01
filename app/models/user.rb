class User < ApplicationRecord
  has_secure_password

  has_many :tasks

  # default is active from db itself
  ALLOWED_STATUSES = ['active', 'in_active']
  validates_inclusion_of :status, in: ALLOWED_STATUSES
  
  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true
end