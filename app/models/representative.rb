class Representative < ApplicationRecord
  
  has_many :representatives_users
  has_many :users, through: :representatives_users
end