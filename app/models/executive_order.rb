class ExecutiveOrder < ApplicationRecord
  validates :title, presence: true
  validates :html_url, presence: true
  validates :executive_order_number, presence: true
  validates :publication_date, presence: true
  validates :pdf_url, presence: true
 
  has_many :executive_orders_users
  has_many :users, through: :executive_orders_users

  def self.find_or_create_from_gateway(executive_order_number:)
    executive_order = ExecutiveOrder.find_by(executive_order_number:)
    return executive_order if executive_order.present?

    found_executive_order = ExecutiveOrderDetailGateway.find_specific_eo(executive_order_number)
    executive_order = ExecutiveOrder.create!(found_executive_order)
  end

  def generate_and_save_summary(text)
    return if summary.present?
    
    generated_summary = OpenaiService.generate_summary(text)
    update(summary: generated_summary) if generated_summary.present?
  end

  # Alias for serialization
  def document_number
    executive_order_number
  end
end
