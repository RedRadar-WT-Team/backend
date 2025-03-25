# app/models/user.rb

class User < ApplicationRecord
  validates_with UserValidator
  validates :email, uniqueness: true
  
  has_many :executive_orders_users
  has_many :executive_orders, through: :executive_orders_users
  has_many :representatives_users
  has_many :representatives, through: :representatives_users
end
