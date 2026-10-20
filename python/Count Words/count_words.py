def count_words(file_path):
    with open(file_path, 'r') as file:
        text = file.read()
    words = text.split()
    return len(words)

file_path = 'textfile.txt'
print(f"Number of words: {count_words(file_path)}")
