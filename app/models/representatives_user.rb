class RepresentativesUser < ApplicationRecord
  belongs_to :representative
  belongs_to :user

  validates :user_id, uniqueness: { scope: :representative_id, message: "already saved this Representative." }
end