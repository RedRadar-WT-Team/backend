class Representative < ApplicationRecord
  has_many :representatives_users
  has_many :users, through: :representatives_users

  validates :name, presence: true
  validates :phone, presence: true
  validates :party, presence: true
  validates :state, presence: true
  validates :district, presence: true
  validates :name, uniqueness: { message: "%{value} already exists in the database." }
end