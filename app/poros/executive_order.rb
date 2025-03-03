class ExecutiveOrder
  attr_reader :id, :title, :html_url, :document_number, :pdf_url, :publication_date

  def initialize(order_data)
    @id               = order_data[:document_number].to_i
    @title            = order_data[:title]
    @document_number  = order_data[:document_number].to_i
    @html_url         = order_data[:html_url]
    @pdf_url          = order_data[:pdf_url]
    @publication_date = parse_date(order_data[:publication_date])
  end

  private

  def parse_date(date_string)
    Date.parse(date_string)
  end
end