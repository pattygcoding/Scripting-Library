import os
import fnmatch
import argparse
from collections import defaultdict

def count_files(include_node):
    current_directory = os.getcwd()
    
    # Get all files recursively
    all_files = []
    for root, dirs, files in os.walk(current_directory):
        if not include_node and 'node_modules' in root:
            continue
        for file in files:
            all_files.append(os.path.join(root, file))

    total_files = len(all_files)
    files_by_extension = defaultdict(int)
    
    for file in all_files:
        _, ext = os.path.splitext(file)
        files_by_extension[ext] += 1

    # Output results
    print("\033[96mTotal number of files: \033[0m\033[93m{}\033[0m".format(total_files))
    print("\033[96mFiles by extension:\033[0m")
    for ext, count in sorted(files_by_extension.items()):
        print("\033[93m{}: {}\033[0m".format(ext, count))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Count files in the current directory, optionally excluding node_modules.')
    parser.add_argument('--includenode', action='store_true', help='Include files in node_modules directory')
    args = parser.parse_args()
    
    count_files(args.includenode)
