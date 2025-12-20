# Makefile for Pidan Workshop development
# Note: Uses Jekyll plugin for multi-language page generation (no manual generation needed)

.PHONY: help dev build clean

help:
	@echo "Pidan Workshop Development Commands:"
	@echo ""
	@echo "  make dev       - Start development server (plugin auto-generates pages)"
	@echo "  make build     - Build the site for production"
	@echo "  make clean     - Clean generated files"
	@echo ""

dev:
	@echo "Starting development environment..."
	@echo "Jekyll will serve at http://localhost:4000"
	@echo "Multi-language pages will be generated automatically by plugin"
	@echo ""
	bundle exec jekyll serve --livereload

build:
	@echo "Building site for production..."
	@echo "Multi-language pages will be generated automatically by plugin"
	bundle exec jekyll build

clean:
	@echo "Cleaning generated files..."
	rm -rf _site
	rm -rf .jekyll-cache
	@echo "Done!"
