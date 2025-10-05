#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Django application...${NC}"

# Wait for database to be ready
echo -e "${YELLOW}Waiting for database...${NC}"
while ! python manage.py dbshell --command="SELECT 1;" >/dev/null 2>&1; do
    echo -e "${YELLOW}Database is unavailable - sleeping${NC}"
    sleep 1
done
echo -e "${GREEN}Database is ready!${NC}"

# Run database migrations
echo -e "${YELLOW}Running database migrations...${NC}"
python manage.py migrate --noinput

# Create superuser if it doesn't exist
echo -e "${YELLOW}Creating superuser if needed...${NC}"
python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print('Superuser created')
else:
    print('Superuser already exists')
"

# Collect static files
echo -e "${YELLOW}Collecting static files...${NC}"
python manage.py collectstatic --noinput

# Create necessary directories
mkdir -p /app/logs

echo -e "${GREEN}Starting application with command: $@${NC}"

# Execute the command
exec "$@"