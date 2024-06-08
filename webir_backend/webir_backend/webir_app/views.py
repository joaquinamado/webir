from django.http import JsonResponse
from .models import GoogleBooks

# Create your views here.


def home(_):
    return JsonResponse({"message": "Hello, world."})


def books(request):
    if request.method != 'GET':
        return JsonResponse({"error": "Invalid request method"}, status=400)

    book = request.GET.get('book', '')

    if book == '':
        return JsonResponse({"error": "Invalid request, 'book' parameter is required"}, status=400)

    print(book)
    allBooks = GoogleBooks.objects.all()
    print(allBooks)
    bookResult = GoogleBooks.objects.filter(titulo__icontains='Yoga')
    print(bookResult)
    bookData = list(bookResult.values())
    print(bookData)
    if bookData == []:
        return JsonResponse({"error": "No books found"}, status=404)

    return JsonResponse(bookData, safe=False, status=200)

