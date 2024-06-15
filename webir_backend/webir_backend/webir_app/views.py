from django.http import JsonResponse
from .models import GoogleBooks, GoodReads, Autores, Categorias


def home(_):
    return JsonResponse({"message": "Hello, world."})


def books(request):
    if request.method != 'GET':
        return JsonResponse({"error": "Invalid request method"}, status=400)

    req_book = request.GET.get('book', '')
    req_autor = request.GET.get('autor', '')
    req_categoria = request.GET.get('categoria', '')
    req_precioMin = request.GET.get('precioMin', '')
    req_precioMax = request.GET.get('precioMax', '')
    req_fechaInicio = request.GET.get('fechaInicio', '')
    req_fechaFin = request.GET.get('fechaFin', '')

    print('Titulo: ' + req_book)
    print('Autor: ' + req_autor)
    print('Categoria: ' + req_categoria)
    print('Precio Min: ' + req_precioMin)
    print('Precio Max: ' + req_precioMax)
    print('Fecha Inicio: ' + req_fechaInicio)
    print('Fecha Fin: ' + req_fechaFin)

    isTitle = True
    # Check if the book is an ISBN
    if len(req_book) == 13:
        try:
            isTitle = False
            int(req_book)
        except ValueError:
            isTitle = True

    if isTitle:
        query = """
            SELECT * FROM googlebooks
            """
        params = []
        if req_book != '':
            query += """
            WHERE similarity(googlebooks.titulo, %s) > 0.1
            """
            params.append(req_book)
        if req_autor != '':
            if req_book == '':
                print('LLEGA 1')
                query += """
                WHERE googlebooks.isbn IN (
                    SELECT isbn FROM autores WHERE similarity(autores.nombre, %s) > 0.8
                )
                """
            else:
                query += """
                AND googlebooks.isbn IN (
                    SELECT isbn FROM autores WHERE similarity(autores.nombre, %s) > 0.8
                )
                """
            params.append(req_autor)
        if req_categoria != '':
            if req_book == '' and req_autor == '':
                query += """
                WHERE googlebooks.isbn IN (
                    SELECT isbn FROM categorias WHERE similarity(categorias.nombre, %s) > 0.8
                )
                """
            else:
                query += """
                AND googlebooks.isbn IN (
                    SELECT isbn FROM categorias WHERE similarity(categorias.nombre, %s) > 0.8
                )
                """
            params.append(req_categoria)
        if (req_precioMin != '0' or req_precioMax != '1000'):
            if req_book == '' and req_autor == '' and req_categoria == '':
                query += """
                WHERE googlebooks.isbn IN (
                    SELECT isbn FROM good_reads WHERE price >= %s AND price <= %s
                )
                """
            else:
                query += """
                AND googlebooks.isbn IN (
                    SELECT isbn FROM good_reads WHERE price >= %s AND price <= %s
                )
                """
            params.append(req_precioMin)
            params.append(req_precioMax)

        if (req_fechaInicio != '' or req_fechaFin != ''):
            if (req_book == '' and req_autor == '' and req_categoria == ''
                and req_precioMin == '0' and req_precioMax == '1000'):
                query += """
                WHERE googlebooks.isbn IN (
                    SELECT isbn FROM googlebooks WHERE
                    TO_DATE(fecha_publicacion, 'YYYY-MM-DD') >=
                    TO_DATE(%s, 'YYYY-MM-DD')
                    AND TO_DATE(fecha_publicacion, 'YYYY-MM-DD') <=
                    TO_DATE(%s, 'YYYY-MM-DD')
                )
                """
                params.append(req_fechaInicio)
                params.append(req_fechaFin)
            else:
                query += """
                AND googlebooks.isbn IN (
                    SELECT isbn FROM googlebooks WHERE 
                    TO_DATE(fecha_publicacion, 'YYYY-MM-DD') 
                    >= TO_DATE(%s, 'YYYY-MM-DD') 
                    AND TO_DATE(fecha_publicacion, 'YYYY-MM-DD') 
                    <= TO_DATE(%s, 'YYYY-MM-DD')
                )
                """
                params.append(req_fechaInicio)
                params.append(req_fechaFin)
        if (req_book != ''):
            query += """
            ORDER BY similarity(googlebooks.titulo, %s) DESC
            """
            params.append(req_book)
        bookResult = GoogleBooks.objects.raw(query, params)
        print('LLEGA')
        print(bookResult)
    if not isTitle:
        isbn = int(req_book)
        bookResult = GoogleBooks.objects.filter(isbn=isbn)

    autores = []
    for book in bookResult:
        autoresResult = Autores.objects.filter(isbn=book.isbn)
        if autoresResult and len(autoresResult) > 0:
            autores.append(autoresResult[0].nombre)
        else:
            autores.append("No author")

    categorias = []
    for book in bookResult:
        categoriasResult = Categorias.objects.filter(isbn=book.isbn)
        if categoriasResult and len(categoriasResult) > 0:
            categorias.append(categoriasResult[0].nombre)
        else:
            categorias.append("No category")

    data = []
    index = 0
    for book in bookResult:
        bookReview = GoodReads.objects.filter(isbn=book.isbn)
        if bookReview:
            precio_kindle = 0
            if bookReview[0].precio_kindle:
                precio_kindle = str(bookReview[0].precio_kindle.split(" ")[1])
                precio_kindle = precio_kindle.replace("$", "")
                try:
                    int(precio_kindle)
                except ValueError:
                    precio_kindle = 0
                print(precio_kindle)
            data.append({
                "isbn": book.isbn,
                "titulo": book.titulo,
                "subtitulo": book.subtitulo,
                "editorial": book.editorial,
                "fecha_publicacion": book.fecha_publicacion,
                "descripcion": book.descripcion,
                "paginas": book.paginas,
                "imagen": book.imagen,
                "idioma": book.idioma,
                "autor": autores[index],
                "precio": str(precio_kindle),
                "categoria": categorias[index],
                "score": {
                    "stars": bookReview[0].stars,
                    "five_stars_cantidad": bookReview[0].five_stars_cantidad,
                    "five_stars_porcentaje": bookReview[0].five_stars_porcentaje,
                    "four_stars_cantidad": bookReview[0].four_stars_cantidad,
                    "four_stars_porcentaje": bookReview[0].four_stars_porcentaje,
                    "three_stars_cantidad": bookReview[0].three_stars_cantidad,
                    "three_stars_porcentaje": bookReview[0].three_stars_porcentaje,
                    "two_stars_cantidad": bookReview[0].two_stars_cantidad,
                    "two_stars_porcentaje": bookReview[0].two_stars_porcentaje,
                    "one_stars_cantidad": bookReview[0].one_stars_cantidad,
                    "one_stars_porcentaje": bookReview[0].one_stars_porcentaje,
                    "precio_kindle": precio_kindle,
                    "scraped_at": bookReview[0].scraped_at
                }
            })
            index += 1
        else:
            data.append({
                "isbn": book.isbn,
                "titulo": book.titulo,
                "subtitulo": book.subtitulo,
                "editorial": book.editorial,
                "fecha_publicacion": book.fecha_publicacion,
                "descripcion": book.descripcion,
                "paginas": book.paginas,
                "imagen": book.imagen,
                "idioma": book.idioma,
                "precio": str(0.0),
                "autor": autores[index],
                "categoria": categorias[index],
            })
            index += 1

    print('DATA: ')
    print(data)
    if data == []:
        return JsonResponse({"error": "No books found"}, status=404)

    return JsonResponse(data, safe=False, status=200)


def authors(request):
    if request.method != 'GET':
        return JsonResponse({"error": "Invalid request method"}, status=400)

    author_names = Autores.objects.values_list('nombre', flat=True).distinct()
    authors = list(author_names)

    return JsonResponse(authors, safe=False, status=200)


def categories(request):
    if request.method != 'GET':
        return JsonResponse({"error": "Invalid request method"}, status=400)

    categories_names = Categorias.objects.values_list('nombre',
                                                      flat=True).distinct()
    categories = list(categories_names)

    return JsonResponse(categories, safe=False, status=200)
