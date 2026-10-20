import requests

def shorten_url(long_url):
    api_url = f'http://tinyurl.com/api-create.php?url={long_url}'
    response = requests.get(api_url)
    return response.text

long_url = 'https://www.example.com'
print(shorten_url(long_url))
