# WORK IN PROGRESS

import re
import argparse

def remove_timestamps(lines):
    pattern = re.compile(r'\[\d{2}:\d{2}:\d{2}\s\w{3}\]|\(\d+ms\)')
    return [pattern.sub('', line) for line in lines]

def compare_diff(file1="TestFile1.txt", file2="TestFile2.txt", no_time=False):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        content1 = f1.readlines()
        content2 = f2.readlines()

    if no_time:
        print("Please note that since you included the --notime flag, timestamps will not be compared or displayed.")
        content1 = remove_timestamps(content1)
        content2 = remove_timestamps(content2)

    differences = []
    max_len = max(len(content1), len(content2))

    for i in range(max_len):
        line1 = content1[i] if i < len(content1) else ''
        line2 = content2[i] if i < len(content2) else ''
        if line1 != line2:
            if line1:
                differences.append(("- " + line1.strip(), "red"))
            if line2:
                differences.append(("+ " + line2.strip(), "green"))

    print(f"\nRED = {file1}")
    print(f"GREEN = {file2}\n")

    for diff, color in differences:
        if color == "red":
            print(f"\033[91m{diff}\033[0m")
        elif color == "green":
            print(f"\033[92m{diff}\033[0m")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare two files line by line.")
    parser.add_argument("file1", nargs='?', default="TestFile1.txt", type=str, help="The first file to compare.")
    parser.add_argument("file2", nargs='?', default="TestFile2.txt", type=str, help="The second file to compare.")
    parser.add_argument("--notime", action="store_true", help="Remove timestamps before comparing.")

    args = parser.parse_args()
    compare_diff(args.file1, args.file2, args.notime)
