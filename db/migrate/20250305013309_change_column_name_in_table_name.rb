class ChangeColumnNameInTableName < ActiveRecord::Migration[7.1]
  def change
    rename_column :executive_orders, :signing_date, :publication_date
  end
end
