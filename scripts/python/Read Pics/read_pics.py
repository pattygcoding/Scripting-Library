import os
import easyocr

reader = easyocr.Reader(['en'])

folder_path = 'PicturesToRead'

for filename in os.listdir(folder_path):
    if filename.lower().endswith('.png'):
        file_path = os.path.join(folder_path, filename)

        try:
            results = reader.readtext(file_path, detail=0)
            print(f"\n===== {filename} =====")
            for line in results:
                print(line)
        except Exception as e:
            print(f"Error reading {filename}: {e}")
