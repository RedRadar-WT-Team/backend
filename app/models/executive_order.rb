class ExecutiveOrder < ApplicationRecord
  validates :title, presence: true
  validates :html_url, presence: true
  validates :executive_order_number, presence: true
  validates :publication_date, presence: true
 
  has_many :executive_orders_users
  has_many :users, through: :executive_orders_users
end