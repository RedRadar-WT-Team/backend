# app/models/user.rb

class User < ApplicationRecord
  validates_with UserValidator
  
  validates :email, uniqueness: true
end
