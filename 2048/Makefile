.PHONY: run run-uv run-venv clean help

VENV = .venv
PYTHON = $(VENV)/bin/python
PIP = $(VENV)/bin/pip

help:
	@echo "Available commands:"
	@echo "  make run        - Run app (uses uv if available, otherwise python3 venv)"
	@echo "  make run-uv     - Run app using uv (fastest, automatic venv & dependencies)"
	@echo "  make run-venv   - Run app using classic python3 -m venv"
	@echo "  make clean      - Clean up virtual environments, database, and cache files"

# Default run target: prefer uv if installed, fallback to classic venv
run:
	@if command -v uv >/dev/null 2>&1; then \
		echo "🚀 Running with uv..."; \
		uv run python app.py; \
	else \
		echo "🐍 uv not found, falling back to python3 -m venv..."; \
		$(MAKE) run-venv; \
	fi

run-uv:
	uv run python app.py

run-venv: $(VENV)/bin/activate
	$(PYTHON) app.py

$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install -r requirements.txt
	touch $(VENV)/bin/activate

clean:
	rm -rf $(VENV) venv
	rm -f database.db
	rm -rf __pycache__ */__pycache__ *.egg-info .pytest_cache
	@echo "✨ Cleaned up environments and cache."
