# app/models/user.rb

class User < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email format is invalid" }
  validates :state, presence: true
  validates :zip, presence: true, format: { with: /\A\d{5}\z/, message: "Must be a valid 5-digit zip code" }
end
