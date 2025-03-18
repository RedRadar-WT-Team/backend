# app/models/user.rb

class User < ApplicationRecord
  validates_with UserValidator
  
  has_many :executive_orders_users
  has_many :executive_orders, through: :executive_orders_users
  validates :email, presence: true, uniqueness: true
end
