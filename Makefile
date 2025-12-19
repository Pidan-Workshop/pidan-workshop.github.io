# Makefile for Pidan Workshop development

.PHONY: help generate dev build clean

help:
	@echo "Pidan Workshop Development Commands:"
	@echo ""
	@echo "  make generate  - Generate language-specific pages from templates"
	@echo "  make dev       - Start development server with auto-regeneration"
	@echo "  make serve     - Start Jekyll server only (without watching templates)"
	@echo "  make build     - Build the site for production"
	@echo "  make clean     - Clean generated files"
	@echo ""

generate:
	@echo "Generating pages from templates..."
	ruby scripts/generate_pages.rb

dev: generate
	@echo "Starting development environment..."
	@echo "Jekyll will serve at http://localhost:4000"
	@echo ""
	bundle exec jekyll serve --livereload

serve:
	@echo "Starting Jekyll server..."
	bundle exec jekyll serve --livereload

build: generate
	@echo "Building site for production..."
	bundle exec jekyll build

clean:
	@echo "Cleaning generated files..."
	rm -rf _site
	rm -rf en/
	rm -rf zh/
	@echo "Done!"
