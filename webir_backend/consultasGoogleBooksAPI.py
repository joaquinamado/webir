import requests
import json
import os
from dotenv import load_dotenv

load_dotenv()


API_KEY = str(os.getenv("API_KEY"))
URL_GOOGLE_BOOKS = "https://www.googleapis.com/books/v1/"

response = requests.get(URL_GOOGLE_BOOKS +"volumes?q=flowers+inauthor:keyes&key="+API_KEY)
json_response = response.json()
print(json.dumps(json_response, indent=4))
