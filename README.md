# Django Dockerfiles

Dockerfiles optimisés pour applications Django avec Gunicorn en production.

## 📁 Fichiers inclus

- `Dockerfile` : Image de production avec Gunicorn + Gevent
- `Dockerfile.dev` : Image de développement avec runserver
- `entrypoint.sh` : Script d'initialisation
- `requirements.txt` : Dépendances production
- `requirements-dev.txt` : Dépendances développement

## 🚀 Utilisation

### Production
```bash
# Build
docker build -t my-django-app .

# Run with environment variables
docker run -p 8000:8000 \
  -e DATABASE_URL=postgresql://user:pass@db:5432/mydb \
  -e DJANGO_SECRET_KEY=your-secret-key \
  my-django-app
```

### Développement
```bash
# Build
docker build -f Dockerfile.dev -t my-django-app-dev .

# Run avec volume pour hot reload
docker run -p 8000:8000 \
  -v $(pwd):/app \
  -e DEBUG=True \
  my-django-app-dev
```

## 🔧 Configuration

### Variables d'environnement requises

Production :
- `DATABASE_URL` : URL de la base de données
- `DJANGO_SECRET_KEY` : Clé secrète Django
- `DJANGO_SETTINGS_MODULE` : Module de settings (défaut: myproject.settings.production)

Optionnelles :
- `REDIS_URL` : URL Redis pour le cache
- `SENTRY_DSN` : DSN Sentry pour monitoring
- `ALLOWED_HOSTS` : Hosts autorisés (défaut: localhost)
- `DEBUG` : Mode debug (défaut: False)

### Structure de projet attendue

```
your-django-app/
├── myproject/
│   ├── __init__.py
│   ├── settings/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── development.py
│   │   └── production.py
│   ├── urls.py
│   └── wsgi.py
├── apps/
├── static/
├── media/
├── templates/
├── requirements.txt
├── requirements-dev.txt
├── manage.py
└── Dockerfile
```

## 🔒 Sécurité

- Utilisateur non-root (`django`)
- Virtual environment isolé
- Variables d'environnement sécurisées
- Static files avec Whitenoise
- CORS configuré

## 📊 Monitoring

- Health check endpoint : `/health/`
- Logs Gunicorn structurés
- Support Sentry intégré
- Métriques Django disponibles

## 🎯 Optimisations

- Multi-stage build
- Gunicorn avec workers Gevent
- Preload application
- Max requests avec jitter
- Static files optimisés
- Database connection pooling

## 🔧 Services additionnels

### Avec Docker Compose
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/mydb
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password

  redis:
    image: redis:7-alpine
```

## 🧪 Testing

```bash
# Run tests in container
docker run --rm my-django-app-dev python manage.py test

# With coverage
docker run --rm my-django-app-dev pytest --cov=.
```