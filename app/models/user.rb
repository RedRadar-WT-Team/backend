# app/models/user.rb

class User < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }
  validates :state, presence: true
  validates :zip, presence: true, format: { with: /\A\d{5}\z/, message: "must be a 5-digit zip code" }
end
