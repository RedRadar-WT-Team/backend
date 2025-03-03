# app/models/user.rb

class User < ApplicationRecord
  validates :email, presence: true
  validates :state, presence: true
  validates :zip, presence: true
end