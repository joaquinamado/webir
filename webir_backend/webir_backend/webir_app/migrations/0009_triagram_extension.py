# from django.contrib.postgres.operations import TrigramExtension
from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ('webir_app', '0008_alter_categorias_isbn'),
    ]

    operations = [
        migrations.RunSQL(
            "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
        ),
    ]
