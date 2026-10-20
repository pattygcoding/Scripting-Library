import requests

def get_weather(city):
    api_key = 'your-api-key'
    base_url = f'http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric'
    response = requests.get(base_url)
    weather_data = response.json()
    
    if weather_data.get('cod') != 200:
        print(weather_data.get('message'))
    else:
        main = weather_data['main']
        wind = weather_data['wind']
        weather_desc = weather_data['weather'][0]['description']
        
        print(f"Temperature: {main['temp']}°C")
        print(f"Humidity: {main['humidity']}%")
        print(f"Wind Speed: {wind['speed']} m/s")
        print(f"Description: {weather_desc}")

city_name = 'London'
get_weather(city_name)
