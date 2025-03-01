class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :state
      t.string :zip_code
      
      t.timestamps
    end
  end
end
