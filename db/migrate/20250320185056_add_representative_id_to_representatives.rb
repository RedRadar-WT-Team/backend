class AddRepresentativeIdToRepresentatives < ActiveRecord::Migration[7.1]
  def change
    add_column :representatives, :representative_id, :string
  end
end
