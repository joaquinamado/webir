# Generated by Django 5.0.6 on 2024-06-11 13:00

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('webir_app', '0007_alter_autores_isbn'),
    ]

    operations = [
        migrations.AlterField(
            model_name='categorias',
            name='isbn',
            field=models.TextField(blank=True, null=True),
        ),
    ]
