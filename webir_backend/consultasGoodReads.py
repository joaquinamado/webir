import scrapy
from scrapy.crawler import CrawlerProcess
import json
import os
import logging
from bs4 import BeautifulSoup
import psycopg2

class BookSpider(scrapy.Spider):
    name = "book"
    allowed_domains = ["goodreads.com"]

    # Reemplaza este ISBN con el ISBN del libro que quieres buscar
    isbn = '9788449326660'
    start_urls = [
        f'https://www.goodreads.com/search?q={isbn}'
    ]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.conn = psycopg2.connect(
            dbname="webir",
            user="postgres",
            password="admin187%",
            host="webir.postgres.database.azure.com",
            port="5432"
        )
        self.cursor = self.conn.cursor()
    
    def parse(self, response):
        logging.info("Entrando en parse")
        
        # Verifica si hay resultados de búsqueda
        book_url = response.css('a.bookTitle::attr(href)').get()
        logging.info(f"URL del libro encontrado: {book_url}")
        
        # Verificar otros posibles selectores
        if not book_url:
            book_url = response.css('a[href*="/book/show/"]::attr(href)').get()
            logging.info(f"URL alternativa del libro encontrada: {book_url}")
        
        if book_url:
            # Manejar URLs completas y relativas
            if book_url.startswith('/'):
                book_url = response.urljoin(book_url)
            logging.info(f"URL completa del libro: {book_url}")
            # Sigue el enlace al libro específico
            yield scrapy.Request(book_url, callback=self.parse_book)
        else:
            logging.info("No se encontraron resultados para el ISBN proporcionado.")

    def separar_cantidad_porcentaje(self, campo):
        # Separar por espacio para dividir cantidad y porcentaje
        partes = campo.split()
        
        # Obtener la cantidad eliminando comas
        cantidad = partes[0].replace(',', '')
        
        # Obtener el porcentaje eliminando paréntesis y el símbolo de porcentaje
        porcentaje = partes[1].strip('()%')
        
        return int(cantidad), int(porcentaje)
    
    def parse_book(self, response):
        logging.info("Entrando en parse_book")
        # Extrae los detalles del libro
        raw_title = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.BookReviewsPage__pageHeader > div.BookReviewsPage__pageTitle > h1.Text.H1Title > a').get()
        soup = BeautifulSoup(raw_title, 'html.parser')
        titulo = soup.get_text(strip=True)
        logging.info(f"Título extraído: {titulo}")

        raw_stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__ratingStatistics > div > div:nth-child(1) > div').get()
        soup = BeautifulSoup(raw_stars, 'html.parser')
        stars = soup.get_text(strip=True)
        logging.info(f"Estrellas extraído: {stars}")

        raw_5stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(1) > div.RatingsHistogram__labelTotal').get()
        soup = BeautifulSoup(raw_5stars, 'html.parser')
        five_stars = soup.get_text(strip=True)
        logging.info(f"5 Estrellas extraído: {five_stars}")

        raw_4stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(2) > div.RatingsHistogram__labelTotal').get()
        soup = BeautifulSoup(raw_4stars, 'html.parser')
        four_stars = soup.get_text(strip=True)
        logging.info(f"4 Estrellas extraído: {four_stars}")

        raw_3stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(3) > div.RatingsHistogram__labelTotal').get()
        soup = BeautifulSoup(raw_3stars, 'html.parser')
        three_stars = soup.get_text(strip=True)
        logging.info(f"3 Estrellas extraído: {three_stars}")

        raw_2stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(4) > div.RatingsHistogram__labelTotal').get()
        soup = BeautifulSoup(raw_2stars, 'html.parser')
        two_stars = soup.get_text(strip=True)
        logging.info(f"2 Estrellas extraído: {two_stars}")

        raw_1stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(5) > div.RatingsHistogram__labelTotal').get()
        soup = BeautifulSoup(raw_1stars, 'html.parser')
        one_stars = soup.get_text(strip=True)
        logging.info(f"1 Estrellas extraído: {one_stars}")

        raw_autor = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.BookReviewsPage__pageHeader > div.BookReviewsPage__pageTitle > h3 > div > span:nth-child(1) > a > span').get()
        soup = BeautifulSoup(raw_autor, 'html.parser')
        autor = soup.get_text(strip=True)
        logging.info(f"Autor extraído: {autor}")

        raw_precio_kindle = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__leftColumn > div > div.BookReviewsPage__bookActions > div > div:nth-child(2) > div > div.Button__container.Button__container--block > button > span:nth-child(1)').get()
        soup = BeautifulSoup(raw_precio_kindle, 'html.parser')
        precio_kindle = soup.get_text(strip=True)
        logging.info(f"Precio Kindle extraido: {precio_kindle}")

        descripcion = response.css('div#description span::text').getall()
        logging.info(f"Descripción extraída: {descripcion}")

        if titulo:
            titulo = titulo.strip()
        if autor:
            autor = autor.strip()
        if stars:
            stars = stars.strip()
        descripcion = ' '.join(descripcion).strip()

        # Manejo de excepciones para la separación de cantidad y porcentaje
        try:
            five_stars_cant, five_stars_porc = self.separar_cantidad_porcentaje(five_stars)
            four_stars_cant, four_stars_porc = self.separar_cantidad_porcentaje(four_stars)
            three_stars_cant, three_stars_porc = self.separar_cantidad_porcentaje(three_stars)
            two_stars_cant, two_stars_porc = self.separar_cantidad_porcentaje(two_stars)
            one_stars_cant, one_stars_porc = self.separar_cantidad_porcentaje(one_stars)
        except Exception as e:
            logging.error(f"Error separando cantidad y porcentaje: {e}")
            five_stars_cant, five_stars_porc = None, None
            four_stars_cant, four_stars_porc = None, None
            three_stars_cant, three_stars_porc = None, None
            two_stars_cant, two_stars_porc = None, None
            one_stars_cant, one_stars_porc = None, None

        book_info = {
            'isbn': self.isbn,
            'titulo': titulo,
            'autor': autor,
            'descripcion': descripcion,
            'stars': float(stars),
            'five_stars_cantidad': five_stars_cant,
            'five_stars_porcentaje': five_stars_porc,
            'four_stars_cantidad': four_stars_cant,
            'four_stars_porcentaje': four_stars_porc,
            'three_stars_cantidad': three_stars_cant,
            'three_stars_porcentaje': three_stars_porc,
            'two_stars_cantidad': two_stars_cant,
            'two_stars_porcentaje': two_stars_porc,
            'one_stars_cantidad': one_stars_cant,
            'one_stars_porcentaje': one_stars_porc,
            'precio_kindle': precio_kindle
        }

        logging.info(f"Detalles del libro: {book_info}")

        # Guardar en la base de datos
        self.save_to_db(book_info)

    def save_to_db(self, book_info):
        logging.info("Guardando datos en la base de datos")
        insert_query = """
        INSERT INTO good_reads (
            isbn, titulo, autor, descripcion, stars, 
            five_stars_cantidad, five_stars_porcentaje, 
            four_stars_cantidad, four_stars_porcentaje, 
            three_stars_cantidad, three_stars_porcentaje, 
            two_stars_cantidad, two_stars_porcentaje, 
            one_stars_cantidad, one_stars_porcentaje, 
            precio_kindle
        ) VALUES (
            %s, %s, %s, %s, %s, 
            %s, %s, %s, %s, %s, 
            %s, %s, %s, %s, %s, 
            %s
        ) ON CONFLICT (isbn) DO NOTHING
        """
        values = (
            book_info['isbn'], book_info['titulo'], book_info['autor'], book_info['descripcion'], book_info['stars'],
            book_info['five_stars_cantidad'], book_info['five_stars_porcentaje'],
            book_info['four_stars_cantidad'], book_info['four_stars_porcentaje'],
            book_info['three_stars_cantidad'], book_info['three_stars_porcentaje'],
            book_info['two_stars_cantidad'], book_info['two_stars_porcentaje'],
            book_info['one_stars_cantidad'], book_info['one_stars_porcentaje'],
            book_info['precio_kindle']
        )
        self.cursor.execute(insert_query, values)
        self.conn.commit()
        logging.info("Datos guardados exitosamente")

    def close(self, reason):
        self.cursor.close()
        self.conn.close()

if __name__ == "__main__":
    # Configurar el logging
    logging.basicConfig(level=logging.INFO)

    # Crear el proceso de Scrapy
    process = CrawlerProcess()
    # Iniciar el spider
    process.crawl(BookSpider)
    # Ejecutar el proceso
    process.start()