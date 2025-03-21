class ChangeRepresentativeIdTypeInRepresentativesUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :representatives_users, :representative_id, :string
  end
end
