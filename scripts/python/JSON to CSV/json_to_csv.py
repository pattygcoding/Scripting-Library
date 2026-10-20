import json
import csv

def json_to_csv(json_file, csv_file):
    with open(json_file) as f:
        data = json.load(f)
    
    with open(csv_file, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(data[0].keys())
        for row in data:
            writer.writerow(row.values())

json_file_path = 'data.json'
csv_file_path = 'data.csv'
json_to_csv(json_file_path, csv_file_path)
