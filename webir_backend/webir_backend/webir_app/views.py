from django.http import JsonResponse
from .models import GoogleBooks, GoodReads, Autores


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
        bookResult = GoogleBooks.objects.filter(titulo__icontains=req_book)
    else:
        isbn = int(req_book)
        bookResult = GoogleBooks.objects.filter(isbn=isbn)

    autores = []
    for book in bookResult:
        autoresResult = Autores.objects.filter(isbn=book.isbn)
        print(autoresResult)
        for autor in autoresResult:
            autores.append(autor.nombre)

    data = []
    for book in bookResult:
        bookReview = GoodReads.objects.filter(isbn=book.isbn)
        if bookReview:
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
                "autor": autores[0],
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
                    "precio_kindle": bookReview[0].precio_kindle,
                    "scraped_at": bookReview[0].scraped_at
                }
            })
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
                "autor": autores[0],
            })

    print(data)
    if data == []:
        return JsonResponse({"error": "No books found"}, status=404)

    return JsonResponse(data, safe=False, status=200)
