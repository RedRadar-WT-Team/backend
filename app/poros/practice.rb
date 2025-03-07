new_eo = [ {:title=>"Implementing the President's \"Department of Government Efficiency\" Cost Efficiency Initiative",
 :type=>"Presidential Document",
 :abstract=>nil,
 :document_number=>"2025-03527",
 :html_url=>"https://www.federalregister.gov/documents/2025/03/03/2025-03527/implementing-the-presidents-department-of-government-efficiency-cost-efficiency-initiative",
 :pdf_url=>"https://www.govinfo.gov/content/pkg/FR-2025-03-03/pdf/2025-03527.pdf",
 :public_inspection_pdf_url=>"https://public-inspection.federalregister.gov/2025-03527.pdf?1740759309",
 :publication_date=>"2025-03-03",
 :agencies=>
  [{:raw_name=>"EXECUTIVE OFFICE OF THE PRESIDENT",
    :name=>"Executive Office of the President",
    :id=>538,
    :url=>"https://www.federalregister.gov/agencies/executive-office-of-the-president",
    :json_url=>"https://www.federalregister.gov/api/v1/agencies/538",
    :parent_id=>nil,
    :slug=>"executive-office-of-the-president"}],
 :excerpts=>nil} ]

#  get all of the pdf URLs and feed those to chat
x = new_eo.map do |eo|
  eo[:pdf_url]
 end

OpenAIGateway.get_summaries(x)

# OpenAIGateway
req.params[:messages]