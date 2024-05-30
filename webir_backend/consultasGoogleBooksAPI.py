import requests
import json
import os

API_KEY = os.environ.get("API_KEY")
URL_GOOGLE_BOOKS = "https://www.googleapis.com/books/v1/"

response = requests.get(URL_GOOGLE_BOOKS +"volumes?q=flowers+inauthor:keyes&key="+API_KEY) 
json_response = response.json()
print(json.dumps(json_response, indent=4))
