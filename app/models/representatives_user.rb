class RepresentativesUser < ApplicationRecord
  belongs_to :representative
  belongs_to :user

  validates :representative_id, uniqueness: { scope: :user_id }
end