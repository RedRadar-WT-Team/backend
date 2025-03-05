class ExecutiveOrdersUser < ApplicationRecord
  belongs_to :executive_order
  belongs_to :user
end