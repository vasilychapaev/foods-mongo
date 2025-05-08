.PHONY: up down restart build laravel-install symfony-install migrate cache-clear test

# Docker commands
up:
	docker-compose up -d

up-dev:
	docker-compose up -d mongodb laravel
	
down:
	docker-compose down
dn: down

restart:
	docker-compose restart

build:
	docker-compose build --no-cache

# Laravel commands
laravel-install:
	docker-compose exec laravel composer install
	docker-compose exec laravel php artisan key:generate
	docker-compose exec laravel php artisan storage:link

laravel-migrate:
	docker-compose exec laravel php artisan migrate

laravel-cache:
	docker-compose exec laravel php artisan cache:clear
	docker-compose exec laravel php artisan config:clear
	docker-compose exec laravel php artisan route:clear
	docker-compose exec laravel php artisan view:clear

# Symfony commands
symfony-install:
	docker-compose exec symfony composer install
	docker-compose exec symfony php bin/console cache:clear

symfony-migrate:
	docker-compose exec symfony php bin/console doctrine:migrations:migrate --no-interaction

symfony-cache:
	docker-compose exec symfony php bin/console cache:clear

# Combined commands
install: laravel-install symfony-install

migrate: laravel-migrate symfony-migrate

cache: laravel-cache symfony-cache

# Test commands
test-laravel:
	docker-compose exec laravel php artisan test

test-symfony:
	docker-compose exec symfony php bin/phpunit

test: test-laravel test-symfony

# Logs
logs:
	docker-compose logs -f

# Create docker directories
init:
	mkdir -p laravel/docker symfony/docker 