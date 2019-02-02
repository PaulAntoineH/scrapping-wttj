require 'open-uri'
require 'nokogiri'
require 'csv'

# extraire les informations des pages des entreprises

puts 'scrapping is starting !'

html_file = open('wttj.html')

html_doc = Nokogiri::HTML(html_file)

# ouvrir le fichier des compagnies
# pour chaque compagnie, definir l'URL et l'ouvrir

CSV.open("./results.csv", 'a') do |csv|
  csv << ['name', 'category', 'location', 'url', 'creation_date', 'employee_number', 'turnover', 'presentation']
end

CSV.foreach('companies.csv') do |row|
  company_name = row[0]
  url = "https://www.welcometothejungle.co/companies/#{company_name}"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  CSV.open("./results.csv", 'a') do |csv|
    html_doc.search('.sc-EHOje').each do |element|
      name = element.search('.cchmzi-2').text if element.search('.cchmzi-2')
      category = element.search('.sc-csuQGl')[0].text.strip if element.search('.sc-csuQGl')[0]
      location = element.search('.sc-csuQGl')[1].text.strip if element.search('.sc-csuQGl')[1]
      url = element.search('.sc-csuQGl')[2].text.strip if element.search('.sc-csuQGl')[2]
      creation_date = element.search('.sc-kXeGPI')[0].text if element.search('.sc-kXeGPI')[0]
      employee_number = element.search('.sc-kXeGPI')[1].text if element.search('.sc-kXeGPI')[1]
      turnover = element.search('.sc-kXeGPI')[4].text if element.search('.sc-kXeGPI')[4]
      presentation = element.search('.sc-eilVRo').text.strip.join if element.search('.sc-eilVRo')
      csv << [name, category, location, url, creation_date, employee_number, turnover, presentation]
    end
  end
end

puts 'scrapping is done !'
