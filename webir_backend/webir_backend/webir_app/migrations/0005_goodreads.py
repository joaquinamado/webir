# Generated by Django 5.0.6 on 2024-06-09 22:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('webir_app', '0004_alter_autores_table_alter_categorias_table_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='GoodReads',
            fields=[
                ('isbn', models.CharField(max_length=13, primary_key=True, serialize=False)),
                ('titulo', models.CharField(max_length=100)),
                ('autor', models.CharField(max_length=100)),
                ('descripcion', models.TextField(blank=True, null=True)),
                ('stars', models.FloatField(blank=True, null=True)),
                ('five_stars_cantidad', models.IntegerField(blank=True, null=True)),
                ('five_stars_porcentaje', models.FloatField(blank=True, null=True)),
                ('four_stars_cantidad', models.IntegerField(blank=True, null=True)),
                ('four_stars_porcentaje', models.FloatField(blank=True, null=True)),
                ('three_stars_cantidad', models.IntegerField(blank=True, null=True)),
                ('three_stars_porcentaje', models.FloatField(blank=True, null=True)),
                ('two_stars_cantidad', models.IntegerField(blank=True, null=True)),
                ('two_stars_porcentaje', models.FloatField(blank=True, null=True)),
                ('one_stars_cantidad', models.IntegerField(blank=True, null=True)),
                ('one_stars_porcentaje', models.FloatField(blank=True, null=True)),
                ('precio_kindle', models.FloatField(blank=True, null=True)),
                ('scraped_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'db_table': 'good_reads',
            },
        ),
    ]
