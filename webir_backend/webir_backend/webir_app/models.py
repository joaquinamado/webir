from django.db import models


class GoogleBooks(models.Model):
    isbn = models.CharField(max_length=13, primary_key=True)
    titulo = models.CharField(max_length=100)
    subtitulo = models.CharField(max_length=100, blank=True, null=True)
    editorial = models.CharField(max_length=100, blank=True, null=True)
    fecha_publicacion = models.CharField(max_length=100, blank=True, null=True)
    descripcion = models.TextField(blank=True, null=True)
    paginas = models.IntegerField(blank=True, null=True)
    imagen = models.TextField(blank=True, null=True)
    idioma = models.CharField(max_length=10, blank=True, null=True)

    def __str__(self) -> str:
        return str(self.titulo)


class Autores(models.Model):
    isbn = models.ForeignKey(GoogleBooks, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=100)

    def __str__(self):
        return str(self.nombre)


class Categorias(models.Model):
    isbn = models.ForeignKey(GoogleBooks, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=100)

    def __str__(self):
        return str(self.nombre)
