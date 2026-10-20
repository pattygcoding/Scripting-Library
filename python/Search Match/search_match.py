import os
import re
import argparse

# Example: python search_match.py .cs Term1 Term2
# --cross is a WIP

def search_match(extension, terms, uncapped=False, cross=False, show_dir=False, calls=False):
    if not extension.startswith('.'):
        extension = f'.{extension}'
    
    max_results = 3000
    results_count = 0
    results_cap_reached = False
    current_dir = os.getcwd()

    def print_result(file_path, line_number, line_content):
        nonlocal results_count, results_cap_reached
        if show_dir:
            print(f"{file_path}")
        else:
            print(f"{os.path.basename(file_path)}")
        print(f"{line_number}\t{line_content.strip()}")
        results_count += 1
        if not uncapped and results_count >= max_results:
            results_cap_reached = True

    for root, _, files in os.walk(current_dir):
        if results_cap_reached:
            break

        for file_name in files:
            if file_name.endswith(extension):
                file_path = os.path.join(root, file_name)
                printed_file_name = False
                skip_using_directives = extension == ".cs"
                search_active = not skip_using_directives
                line_number = 0
                term_matches = {term: [] for term in terms} if cross else None

                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
                        for line in file:
                            line_number += 1
                            if skip_using_directives and line.strip().startswith("using "):
                                continue

                            if skip_using_directives and not line.strip().startswith("using "):
                                search_active = True
                                skip_using_directives = False

                            if search_active:
                                for term in terms:
                                    escaped_term = re.escape(term)

                                    if cross:
                                        if re.search(escaped_term, line):
                                            term_matches[term].append((line_number, line))
                                    else:
                                        if re.search(escaped_term, line) and (not calls or re.search(r'\.' + escaped_term, line)):
                                            if not printed_file_name:
                                                if show_dir:
                                                    print(f"{file_path}", end="\n")
                                                else:
                                                    print(f"{os.path.basename(file_path)}", end="\n")
                                                printed_file_name = True

                                            print_result(file_path, line_number, line)

                                            if results_cap_reached:
                                                break
                                if results_cap_reached:
                                    break

                except Exception as e:
                    print(f"An error occurred while processing file {file_path}: {e}")

                if cross and all(term_matches.values()):
                    if show_dir:
                        print(f"{file_path}")
                    else:
                        print(f"{os.path.basename(file_path)}")
                    for term, matches in term_matches.items():
                        for line_num, line_content in matches:
                            print(f"{line_num}\t{line_content.strip()}")

                    results_count += 1
                    if not uncapped and results_count >= max_results:
                        results_cap_reached = True
                        break

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Search for patterns in files.")
    parser.add_argument("extension", type=str, help="File extension to search (e.g., .txt).")
    parser.add_argument("terms", nargs='+', help="Terms to search for in the files.")
    parser.add_argument("--uncapped", action="store_true", help="List more than the limit of 3000 results.")
    parser.add_argument("--cross", action="store_true", help="Only search for files that have all of the strings, not just any.")
    parser.add_argument("--dir", action="store_true", help="Display the full file directories, not just the file names.")
    parser.add_argument("--calls", action="store_true", help="Display only if there is a period (.) before the string. Useful for locating function calls.")

    args = parser.parse_args()
    search_match(args.extension, args.terms, args.uncapped, args.cross, args.dir, args.calls)
