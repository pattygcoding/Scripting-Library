require 'json'
require 'csv'

def json_to_csv(json_file, csv_file)
  data = JSON.parse(File.read(json_file))
  
  CSV.open(csv_file, 'w') do |csv|
    csv << data[0].keys
    data.each do |row|
      csv << row.values
    end
  end
end

json_file_path = 'data.json'
csv_file_path = 'data.csv'
json_to_csv(json_file_path, csv_file_path)
