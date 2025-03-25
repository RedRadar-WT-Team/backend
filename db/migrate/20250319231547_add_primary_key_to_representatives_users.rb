class AddPrimaryKeyToRepresentativesUsers < ActiveRecord::Migration[7.1]
  def change
    drop_table :representatives_users, if_exists: true

    create_table :representatives_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :representative, null: false, foreign_key: true

      t.timestamps
    end
  end
end
