from django.http import JsonResponse
from .models import GoogleBooks, GoodReads, Autores, Categorias


def home(_):
    return JsonResponse({"message": "Hello, world."})


def books(request):
    if request.method != 'GET':
        return JsonResponse({"error": "Invalid request method"}, status=400)


    req_book = request.GET.get('book', '')

    if req_book == '':
        return JsonResponse({"error": "Invalid request, 'book' parameter is required"}, status=400)

    isTitle = True
    # Check if the book is an ISBN
    if len(req_book) == 13:
        try:
            isTitle = False
        except ValueError:
            isTitle = True

    if isTitle:
        bookResult = GoogleBooks.objects.raw(
                """
                SELECT * FROM googlebooks
                WHERE similarity(titulo, %s) > 0.1
                ORDER BY similarity(titulo, %s) DESC
                """,
                [req_book, req_book]
                )
        #bookResult = GoogleBooks.objects.filter(titulo__icontains=req_book)
    else:
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
 
    categories_names = Categorias.objects.values_list('nombre', flat=True).distinct()
    categories = list(categories_names)


    return JsonResponse(categories, safe=False, status=200)
