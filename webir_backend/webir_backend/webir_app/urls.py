from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('books/', views.books, name='books'),
    path('authors/', views.authors, name='authors'),
    path('categories/', views.categories, name='categories'),
]
