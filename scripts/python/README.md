# Python Scripts by Patrick Goodwin
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org/)

## Table of Contents
- [Backend File Explorer](#backend-file-explorer)
- [Compare Diff](#compare-diff)
- [Count Files](#count-files)
- [Count Words](#count-words)
- [Generate QR Code](#generate-qr-code)
- [Get Directory Size](#get-directory-size)
- [Get Links](#get-links)
- [Get System Info](#get-system-info)
- [Get Weather](#get-weather)
- [Instant GUI](#instant-gui)
- [JSON to CSV](#json-to-csv)
- [Merge PDFs](#merge-pdfs)
- [Organize Directory](#organize-directory)
- [Print Directory Tree](#print-directory-tree)
- [Random Password](#random-password)
- [Read Pics](#read-pics)
- [Resize Image](#resize-image)
- [Search Match](#search-match)
- [Send Email](#send-email)
- [Shorten URL](#shorten-url)
- [Update Git](#update-git)
- [Venn Diagram](#venn-diagram)

## Backend File Explorer
This script provides a GUI-based file explorer for opening files in different editors. It supports multiple file extensions and can open files in Visual Studio, VS Code, or Android Studio.

### Dependencies
- `tkinter`: Built-in Python GUI library
- `win32com.client`: For Visual Studio integration

### Features
- Supports multiple file extensions (.cs, .c, .java, .dart, .vue, .php, .ts, .js, .py, .html, .css, .json, .xml, .cpp)
- Search and autocomplete functionality
- Integration with Visual Studio, VS Code, and Android Studio
- Ignores common directories like node_modules, .git, build, dist, vendor, __pycache__

### Example Usage
```python
python backend_file_explorer.py
```

## Compare Diff
This script compares two files line by line and highlights the differences. It also has an optional feature to ignore timestamps during the comparison.

### Arguments
- `file1`: The first file to compare. Defaults to `TestFile1.txt`.
- `file2`: The second file to compare. Defaults to `TestFile2.txt`.
- `--notime`: Optional flag to remove timestamps before comparing.

### Example Usage
```
python compare_diff.py file1.txt file2.txt
```

## Count Files
This script counts the number of files in the current directory and its subdirectories. It can optionally exclude the `node_modules` directory.

### Arguments
- `--includenode`: Include files in the `node_modules` directory.

### Example Usage
```
python count_files.py
```

## Count Words
This script counts the number of words in a specified text file.

### Example Usage
```
python count_words.py
```

## Generate QR Code
This script generates a QR code for a link.

### Example Usage
```
python generate_qr_code.py
```

## Get Directory Size
This script returns the byte size of your directory.

### Example Usage
```
python get_directory_size.py
```

## Get Links
This script returns links inside of a URL.

### Example Usage
```
python get_links.py
```

## Get System Info
This script returns your computer's system information.

### Example Usage
```
python get_system_info.py
```

## Get Weather
This script returns the weather of a given city.

### Example Usage
```
python get_weather.py
```

## Instant GUI
This script generates an instant GUI.

### Example Usage
```
python instant_gui.py
```

## JSON to CSV
This script converts a JSON file to CSV.

### Example Usage
```
python json_to_csv.py
```

## Merge PDFs
This script merges the contents of multiple PDFs into one.

### Example Usage
```
python merge_pdfs.py
```

## Organize Directory
This script organizees yoyr directory by file extension.

### Example Usage
```
python organize_directory.py
```

## Print Directory Tree
This script prints your current directory tree on the terminal.

### Example Usage
```
python print_directory_tree.py
```

## Random Password
This script generates a random password.

### Example Usage
```
python random_password.py
```

## Read Pics
This script reads text from PNG images using Optical Character Recognition (OCR). It processes all PNG files in a 'PicturesToRead' folder and extracts text content from them.

### Dependencies
- `easyocr`: OCR library for text recognition

### Requirements
- A folder named 'PicturesToRead' containing PNG images
- Install easyocr: `pip install easyocr`

### Example Usage
```python
python read_pics.py
```

## Resize Image
This script resizes an image.

### Example Usage
```
python resize_image.py
```

## Search Match
This script searches for patterns in files within the current directory and its subdirectories. It supports various options, including uncapped results, cross-term search, full directory display, and filtering based on function call patterns.

### Arguments
- `extension`: File extension to search (e.g., `.txt`).
- `terms`: One or more terms to search for in the files.
- `--uncapped`: List more than the limit of 3000 results.
- `--cross`: Only search for files that contain all of the specified terms.
- `--dir`: Display the full file directories, not just the file names.
- `--calls`: Display only if there is a period (.) before the string. Useful for locating function calls.

### Example Usage
```
python search_match.py .cs Term1 Term2
```

## Send Email
This script sends an email from python.

### Example Usage
```
python send_email.py
```

## Shorten URL
This script shortens a URL.

### Example Usage
```
python shorten_url.py
```

## Update Git
This script updates the current Git branch by fetching the latest changes and merging them from a specified branch (default is `master`).

### Arguments
- `-branch`: The branch to merge into the current branch. If not specified, `master` is used.

### Example Usage
```
python update_git.py -branch develop
```

## Venn Diagram
This script creates a visual Venn diagram showing the relationship between two sets. It displays items that are unique to each set as well as items that are shared between them.

### Dependencies
- `matplotlib`: Plotting library
- `matplotlib_venn`: Venn diagram extension for matplotlib

### Requirements
- Install dependencies: `pip install matplotlib matplotlib-venn`

### Features
- Creates a two-set Venn diagram
- Customizable set labels and content
- Visual representation of set relationships
- Shows unique and shared items

### Example Usage
```python
python venn-diagram.py
```
