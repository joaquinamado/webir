from django.db import models


class GoodReads(models.Model):
    isbn = models.CharField(max_length=13, primary_key=True)
    titulo = models.CharField(max_length=100)
    autor = models.CharField(max_length=100)
    descripcion = models.TextField(blank=True, null=True)  
    stars = models.FloatField(blank=True, null=True)
    five_stars_cantidad = models.IntegerField(blank=True, null=True)
    five_stars_porcentaje = models.FloatField(blank=True, null=True)
    four_stars_cantidad = models.IntegerField(blank=True, null=True)
    four_stars_porcentaje = models.FloatField(blank=True, null=True)
    three_stars_cantidad = models.IntegerField(blank=True, null=True)
    three_stars_porcentaje = models.FloatField(blank=True, null=True)
    two_stars_cantidad = models.IntegerField(blank=True, null=True)
    two_stars_porcentaje = models.FloatField(blank=True, null=True)
    one_stars_cantidad = models.IntegerField(blank=True, null=True)
    one_stars_porcentaje = models.FloatField(blank=True, null=True)
    precio_kindle = models.FloatField(blank=True, null=True)
    scraped_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'good_reads'

    def __str__(self) -> str:
        return str(self.titulo)





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

    class Meta:
        db_table = 'googlebooks'

    def __str__(self) -> str:
        return str(self.titulo)


class Autores(models.Model):
    id = models.AutoField(primary_key=True)
    isbn = models.TextField(blank=True, null=True)
    # isbn = models.ForeignKey(GoogleBooks, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=100)

    class Meta:
        db_table = 'autores'

    def __str__(self):
        return str(self.nombre)


class Categorias(models.Model):
    id = models.AutoField(primary_key=True)
    isbn = models.ForeignKey(GoogleBooks, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=100)

    class Meta:
        db_table = 'categorias'

    def __str__(self):
        return str(self.nombre)
