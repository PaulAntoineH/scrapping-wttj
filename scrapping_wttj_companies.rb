require 'open-uri'
require 'nokogiri'
require 'csv'

# extraire les noms des entreprises

html_file = open('wttj_companies.html')

html_doc = Nokogiri::HTML(html_file, nil, Encoding::UTF_8.to_s)


CSV.open("./companies_not_treated.csv", 'wb') do |csv|
  csv << ['name', 'category']
  html_doc.search('.ais-Hits-item').each do |element|
    name = element.search('.ais-Highlight-nonHighlighted').text.strip.downcase.gsub(/\s/, '-') if element.search('.cchmzi-2')
    category = element.search('.sc-csuQGl')[0].text.strip if element.search('.sc-csuQGl')
    csv << [name, category]
  end
end
