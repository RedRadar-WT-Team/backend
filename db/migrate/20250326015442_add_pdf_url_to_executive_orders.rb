class AddPdfUrlToExecutiveOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :executive_orders, :pdf_url, :string
  end
end
