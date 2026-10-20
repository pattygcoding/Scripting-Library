import os
import shutil

def organize_directory(directory):
    for filename in os.listdir(directory):
        if os.path.isfile(os.path.join(directory, filename)):
            ext = filename.split('.')[-1]
            ext_folder = os.path.join(directory, ext)
            if not os.path.exists(ext_folder):
                os.makedirs(ext_folder)
            shutil.move(os.path.join(directory, filename), os.path.join(ext_folder, filename))

directory_path = '/path/to/your/directory'
organize_directory(directory_path)
