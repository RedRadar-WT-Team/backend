class ExecutiveOrderSerializer
  include JSONAPI::Serializer

  attributes :id,
             :title,
             :document_number,
             :html_url,
             :pdf_url,
             :publication_date 
end


 