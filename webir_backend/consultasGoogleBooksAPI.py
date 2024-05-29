import requests
import json

API_KEY = "AIzaSyAF1lpq-_SjjC5aNCDDOAdnpLZ2Bx4BuQo"
URL_GOOGLE_BOOKS = "https://www.googleapis.com/books/v1/"

response = requests.get(URL_GOOGLE_BOOKS +"volumes?q=flowers+inauthor:keyes&key="+API_KEY) 
json_response = response.json()
print(json.dumps(json_response, indent=4))