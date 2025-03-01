class CreateRepresentatives < ActiveRecord::Migration[7.1]
  def change
    create_table :representatives do |t|
      t.string :name
      t.string :phone
      t.string :photo_url
      t.string :party
      t.string :state
      t.string :district
      t.string :area
      t.string :reason 

      t.timestamps
    end
  end
end
