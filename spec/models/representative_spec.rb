require 'rails_helper'

RSpec.describe Representative, type: :model do
  # describe "relationships" do
  #   it { should have_many(:representatives_users) }
  #   it { should have_many(:users).through(:representatives_users) }
  # end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:party) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:district) }

    it "validates uniqueness of name" do
      Representative.create(
        name: "Alex Padilla",
        phone: "202-224-3553",
        party: "Democrat",
        state: "CA",
        district: "11"
      )

      representative = Representative.new(
        name: "Alex Padilla",
        phone: "202-224-3553",
        party: "Democrat",
        state: "CA",
        district: "11"
      )

      representative.valid?
      expect(representative.errors[:name]).to include("Alex Padilla already exists in the database.")
    end
  end
end
