require 'csv'
require 'json'

root=$HOME
jsondoc='downtown.json'
csvdoc='downtown'

CSV.open("mycsv.csv", "wb") do |csv| #open new file for write
  JSON.parse(File.open("#{jsondoc}").read).each do |hash| #open json to parse
    csv << hash.values #write value to file
  end
end