class ExecutiveOrdersUser < ApplicationRecord
  belongs_to :executive_order
  belongs_to :user

  validates :user_id, uniqueness: { scope: :executive_order_id }
end