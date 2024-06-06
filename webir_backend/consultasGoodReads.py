from datetime import datetime
import scrapy
from scrapy.crawler import CrawlerProcess, CrawlerRunner
from scrapy.utils.log import configure_logging
from twisted.internet import reactor, defer
import logging
from bs4 import BeautifulSoup
import psycopg2
from psycopg2.pool import SimpleConnectionPool

class BookSpider(scrapy.Spider):
    name = "book"
    allowed_domains = ["goodreads.com"]

    def __init__(self, isbn=None, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.isbn = isbn
        self.start_urls = [f'https://www.goodreads.com/search?q={isbn}']
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
        if not book_url:
            book_url = response.url
        
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
        if (raw_title):
            soup = BeautifulSoup(raw_title, 'html.parser')
            titulo = soup.get_text(strip=True)
        else:
            raw_title = response.css('head > title').get()
            if (raw_title):
                soup = BeautifulSoup(raw_title, 'html.parser')
                titulo = soup.get_text(strip=True)
            else:
                titulo = "Sin titulo"
        logging.info(f"Título extraído: {titulo}")

        raw_stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__ratingStatistics > div > div:nth-child(1) > div').get()
        if (raw_stars):
            soup = BeautifulSoup(raw_stars, 'html.parser')
            stars = soup.get_text(strip=True)
            logging.info(f"Estrellas extraído: {stars}")
        else:
            raw_stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookPage__gridContainer > div.BookPage__rightColumn > div.BookPage__mainContent > div.BookPageMetadataSection > div.BookPageMetadataSection__ratingStats > a > div:nth-child(1)').get()
            if (raw_stars):
                soup = BeautifulSoup(raw_stars, 'html.parser')
                stars = soup.get_text(strip=True)
                logging.info(f"Estrellas extraído: {stars}")
            else:
                stars = "Sin entrellas"

        raw_5stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(1) > div.RatingsHistogram__labelTotal').get()
        if (raw_5stars):
            soup = BeautifulSoup(raw_5stars, 'html.parser')
            five_stars = soup.get_text(strip=True)
            logging.info(f"5 Estrellas extraído: {five_stars}")
        else:
            raw_5stars = response.css('#ReviewsSection > div:nth-child(7) > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(1) > div.RatingsHistogram__labelTotal').get()
            if (raw_5stars):
                soup = BeautifulSoup(raw_5stars, 'html.parser')
                five_stars = soup.get_text(strip=True)
                logging.info(f"5 Estrellas extraído: {stars}")
            else:
                five_stars = "Sin 5 estrellas"
        
        
        raw_4stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(2) > div.RatingsHistogram__labelTotal').get()
        if (raw_4stars):
            soup = BeautifulSoup(raw_4stars, 'html.parser')
            four_stars = soup.get_text(strip=True)
            logging.info(f"4 Estrellas extraído: {four_stars}")
        else:
            raw_4stars = response.css('#ReviewsSection > div:nth-child(7) > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(2) > div.RatingsHistogram__labelTotal').get()
            if (raw_4stars):
                soup = BeautifulSoup(raw_4stars, 'html.parser')
                four_stars = soup.get_text(strip=True)
                logging.info(f"4 Estrellas extraído: {four_stars}")
            else:
                four_stars = "Sin 4 estrellas"
        
        
        raw_3stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(3) > div.RatingsHistogram__labelTotal').get()
        if (raw_3stars):
            soup = BeautifulSoup(raw_3stars, 'html.parser')
            three_stars = soup.get_text(strip=True)
            logging.info(f"3 Estrellas extraído: {three_stars}")
        else:
            raw_3stars = response.css('#ReviewsSection > div:nth-child(7) > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(3) > div.RatingsHistogram__labelTotal').get()
            if (raw_3stars):
                soup = BeautifulSoup(raw_3stars, 'html.parser')
                three_stars = soup.get_text(strip=True)
                logging.info(f"3 Estrellas extraído: {three_stars}")
            else:
                three_stars = "Sin 3 estrellas"
        
        
        
        raw_2stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(4) > div.RatingsHistogram__labelTotal').get()
        if (raw_2stars):
            soup = BeautifulSoup(raw_2stars, 'html.parser')
            two_stars = soup.get_text(strip=True)
            logging.info(f"2 Estrellas extraído: {two_stars}")
        else:
            raw_2stars = response.css('#ReviewsSection > div:nth-child(7) > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(4) > div.RatingsHistogram__labelTotal').get()
            if (raw_2stars): 
                soup = BeautifulSoup(raw_2stars, 'html.parser')
                two_stars = soup.get_text(strip=True)
                logging.info(f"2 Estrellas extraído: {two_stars}")
            else:
                two_stars = "Sin 2 estrellas"
        
        raw_1stars = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(5) > div.RatingsHistogram__labelTotal').get()
        if (raw_1stars):
            soup = BeautifulSoup(raw_1stars, 'html.parser')
            one_stars = soup.get_text(strip=True)
            logging.info(f"1 Estrellas extraído: {one_stars}")
        else:
            raw_1stars = response.css('#ReviewsSection > div:nth-child(7) > div.ReviewsSectionStatistics > div.ReviewsSectionStatistics__histogram > div > div:nth-child(5) > div.RatingsHistogram__labelTotal').get()
            if (raw_1stars):
                soup = BeautifulSoup(raw_1stars, 'html.parser')
                one_stars = soup.get_text(strip=True)
                logging.info(f"1 Estrellas extraído: {one_stars}")
            else:
                one_stars = "Sin 1 estrellas"
        
        raw_autor = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__rightColumn > div.BookReviewsPage__pageHeader > div.BookReviewsPage__pageTitle > h3 > div > span:nth-child(1) > a > span').get()
        if (raw_autor):
            soup = BeautifulSoup(raw_autor, 'html.parser')
            autor = soup.get_text(strip=True)
            logging.info(f"Autor extraído: {autor}")
        else:
            raw_autor = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookPage__gridContainer > div.BookPage__rightColumn > div.BookPage__mainContent > div.BookPageMetadataSection > div.BookPageMetadataSection__contributor > h3 > div > span:nth-child(1) > a > span').get()
            if (raw_autor):
                soup = BeautifulSoup(raw_autor, 'html.parser')
                autor = soup.get_text(strip=True)
                logging.info(f"Autor extraído: {autor}")
            else:
                autor = "Sin autor"

        raw_precio_kindle = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookReviewsPage__gridContainer > div.BookReviewsPage__leftColumn > div > div.BookReviewsPage__bookActions > div > div:nth-child(2) > div > div.Button__container.Button__container--block > button > span:nth-child(1)').get()
        if (raw_precio_kindle):
            soup = BeautifulSoup(raw_precio_kindle, 'html.parser')
            precio_kindle = soup.get_text(strip=True)
            logging.info(f"Precio Kindle extraido: {precio_kindle}")
        else:
            raw_precio_kindle = response.css('#__next > div.PageFrame.PageFrame--siteHeaderBanner > main > div.BookPage__gridContainer > div.BookPage__leftColumn > div > div.BookActions > div:nth-child(2) > div > div.Button__container.Button__container--block > button > span:nth-child(1)').get()
            if (raw_precio_kindle):
                soup = BeautifulSoup(raw_precio_kindle, 'html.parser')
                precio_kindle = soup.get_text(strip=True)
                logging.info(f"Precio Kindle extraido: {precio_kindle}")
            else:
                precio_kindle = "Sin precio Kindle"  
                  
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
        
        # Agregar la fecha y hora del scraping
        scraped_at = datetime.now()

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
            'precio_kindle': precio_kindle,
            'scraped_at': scraped_at
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
            precio_kindle, scraped_at
        ) VALUES (
            %s, %s, %s, %s, %s, 
            %s, %s, %s, %s, %s, 
            %s, %s, %s, %s, %s, 
            %s, %s
        ) ON CONFLICT (isbn) DO NOTHING
        """
        values = (
            book_info['isbn'], book_info['titulo'], book_info['autor'], book_info['descripcion'], book_info['stars'],
            book_info['five_stars_cantidad'], book_info['five_stars_porcentaje'],
            book_info['four_stars_cantidad'], book_info['four_stars_porcentaje'],
            book_info['three_stars_cantidad'], book_info['three_stars_porcentaje'],
            book_info['two_stars_cantidad'], book_info['two_stars_porcentaje'],
            book_info['one_stars_cantidad'], book_info['one_stars_porcentaje'],
            book_info['precio_kindle'], book_info['scraped_at']
        )
        self.cursor.execute(insert_query, values)
        self.conn.commit()
        logging.info("Datos guardados exitosamente")

    def close(self, reason):
        self.cursor.close()
        self.conn.close()

def get_isbns_from_db():
    pool = SimpleConnectionPool(
        1,
        20,
        dbname="webir",
        user="postgres",
        password="admin187%",
        host="webir.postgres.database.azure.com",
        port="5432",
    )
    try:
        with pool.getconn() as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT isbn FROM googlebooks WHERE isbn NOT IN (SELECT isbn FROM good_reads)")
                isbns = cursor.fetchall()
                return [isbn[0] for isbn in isbns if isbn[0]]
    except Exception as e:
        logging.error(f"Error al conectar con la base de datos: {e}")
        return []

@defer.inlineCallbacks
def run_multiple_crawls(isbns):
    runner = CrawlerRunner()
    for isbn in isbns:
        yield runner.crawl(BookSpider, isbn=isbn)
    reactor.stop()

if __name__ == "__main__":
    # Configurar el logging
    configure_logging()
    logging.basicConfig(level=logging.INFO)

    # Obtener los ISBN desde la base de datos
    isbns = get_isbns_from_db()

    # Ejecutar múltiples spiders
    run_multiple_crawls(isbns)
    reactor.run()
