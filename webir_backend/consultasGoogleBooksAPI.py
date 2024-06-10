import requests
import json
import os
from dotenv import load_dotenv
import psycopg2

load_dotenv()
API_KEY = str(os.getenv("API_KEY"))
URL_GOOGLE_BOOKS = "https://www.googleapis.com/books/v1/"
GENERO = "PHILOSOPHY"

def queryGoogleBooksApi(start_index):
    print("Consultando la API de Google Books...")
    response = requests.get(URL_GOOGLE_BOOKS + "volumes?q=subject:"+ GENERO+ "&startIndex="+str(start_index)+"&maxResults=40&key=AIzaSyAF1lpq-_SjjC5aNCDDOAdnpLZ2Bx4BuQo")
    json_response = response.json()
    print("Consulta exitosa")
    return json_response

def createsTables(conn, cursor):
    conn, cursor = connectToDB()
    print("Creando tablas en la base de datos...")
    cursor.execute("CREATE TABLE IF NOT EXISTS GoogleBooks (isbn VARCHAR(13) PRIMARY KEY, titulo VARCHAR(100), subtitulo VARCHAR(100), editorial VARCHAR(100), fecha_publicacion VARCHAR(100), descripcion TEXT, paginas INT, imagen TEXT, idioma VARCHAR(10))")
    cursor.execute("CREATE TABLE IF NOT EXISTS Autores (id SERIAL PRIMARY KEY, isbn VARCHAR(13), nombre VARCHAR(100))")
    cursor.execute("CREATE TABLE IF NOT EXISTS Categorias (id SERIAL PRIMARY KEY, isbn VARCHAR(13), nombre VARCHAR(100))")
    conn.commit()
    print("Tablas creadas exitosamente")

def connectToDB():
    print("Conectando a la base de datos...")
    conn = psycopg2.connect(
            dbname="webir",
            user="postgres",
            password="admin187%",
            host="webir.postgres.database.azure.com",
            port="5432"
        )
    cursor = conn.cursor()
    print("Conexión exitosa")
    return conn, cursor

def close(conn, cursor):
    cursor.close()
    conn.close()
    print("Conexión a la base de datos cerrada")

def get_book_isbn13(industryIdentifiers):
    for identifier in industryIdentifiers:
        if identifier["type"] == "ISBN_13":
            return identifier["identifier"]
    return None

def apiResponseToBookInfo(start_index):
    print("Procesando respuesta de la API")
    json_response = queryGoogleBooksApi(start_index)
    books_info = []
    size = 0
    for item in json_response["items"]:
        size += 1
        if "industryIdentifiers" not in item["volumeInfo"]:
            continue
        if get_book_isbn13(item["volumeInfo"]["industryIdentifiers"]) == None:
            continue
        if "authors" not in item["volumeInfo"]:
            continue
        book_info = {
            'isbn': get_book_isbn13(item["volumeInfo"]["industryIdentifiers"]),
            'titulo': item["volumeInfo"]["title"],
            'subtitulo': item["volumeInfo"]["subtitle"] if "subtitle" in item["volumeInfo"] else None,
            'autores': item["volumeInfo"]["authors"],               #es un arreglo
            'editorial': item["volumeInfo"]["publisher"] if "publisher" in item["volumeInfo"] else None,
            'fecha_publicacion': item["volumeInfo"]["publishedDate"],
            'descripcion': item["volumeInfo"]["description"] if "description" in item["volumeInfo"] else None,
            'paginas': item["volumeInfo"]["pageCount"] if "pageCount" in item["volumeInfo"] else None,
            'categorias': item["volumeInfo"]["categories"] if "categories" in item["volumeInfo"] else [],         #es un arreglo
            'imagen': item["volumeInfo"]["imageLinks"]["thumbnail"] if "imageLinks" in item["volumeInfo"] else None,
            'idioma': item["volumeInfo"]["language"]
        }
        books_info.append(book_info)
    print("Procesamiento exitoso")
    print("Cantidad de libros procesados: ", size)
    return books_info

def saveBookInfoToDB(books_info, conn, cursor):
    print("Guardando información en la base de datos...")
    insertQueryBooks = "INSERT INTO GoogleBooks (isbn, titulo, subtitulo, editorial, fecha_publicacion, descripcion, paginas, imagen, idioma) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) ON CONFLICT (isbn) DO NOTHING"
    insertQueryAuthors = "INSERT INTO Autores (isbn, nombre) VALUES (%s, %s)"
    insertQueryCategories = "INSERT INTO Categorias (isbn, nombre) VALUES (%s, %s)"
    for book in books_info:
        bookValues = (book["isbn"], book["titulo"], book["subtitulo"], book["editorial"], book["fecha_publicacion"], book["descripcion"], book["paginas"], book["imagen"], book["idioma"])

        for autor in book["autores"]:
            autorValues = (book["isbn"], autor)
            cursor.execute(insertQueryAuthors, autorValues)

        for categoria in book["categorias"]:
            categoriaValues = (book["isbn"], categoria)
            cursor.execute(insertQueryCategories, categoriaValues)

        cursor.execute(insertQueryBooks, bookValues)
    conn.commit()
    print("Información guardada exitosamente")

if __name__ == "__main__":
    conn, cursor = connectToDB()
    createsTables(conn, cursor)
    search = queryGoogleBooksApi(0)
    total_items = search["totalItems"]
    for i in range(0, total_items, 40):
        books_info = apiResponseToBookInfo(i)
        saveBookInfoToDB(books_info, conn, cursor)
    close(conn, cursor)
    
