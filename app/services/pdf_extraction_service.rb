require 'pdf-reader'
require 'open-uri'

class PdfExtractionService
  def self.extract_text(pdf_url)
    return nil if pdf_url.blank?

    begin
      # Download PDF content
      pdf_content = URI.open(pdf_url)
      
      # Extract text from PDF
      
      reader = PDF::Reader.new(pdf_content)

      extracted_text = ""
      reader.pages.each do |page|
        extracted_text << page.text
      end
      
      # Clean up text
      clean_text(extracted_text)
    rescue => e
      Rails.logger.error("PDF extraction error for #{pdf_url}: #{e.message}")
      nil
    end
  end

  private

  def self.clean_text(text)
    # Remove extra whitespace and normalize line endings
    text.gsub(/\s+/, ' ').strip
  end
end
