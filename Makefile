.PHONY: help install test lint format clean migrate run

help:
	@echo "Available commands:"
	@echo "  make install    - Install dependencies"
	@echo "  make test       - Run tests"
	@echo "  make lint       - Run linting"
	@echo "  make format     - Format code with Black"
	@echo "  make migrate    - Run database migrations"
	@echo "  make run        - Start development server"
	@echo "  make clean      - Clean temporary files"

install:
	pip install -r requirements.txt

test:
	pytest

lint:
	flake8 src/ --count --show-source --statistics
	black --check src/

format:
	black src/
	isort src/

migrate:
	python src/backend/manage.py migrate

run:
	python src/backend/manage.py runserver

clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name ".DS_Store" -delete
