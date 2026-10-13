.PHONY: help slides export-slides docker-slides run-2048 clean

help:
	@echo "🚀 Vibe Coding Workshop - Helper Commands:"
	@echo "  make slides         - Run Go present presentation locally on port 3999"
	@echo "  make export-slides  - Export slides to standalone static HTML (public/)"
	@echo "  make docker-slides  - Build and run slides in a Docker container"
	@echo "  make run-2048       - Launch the 2048 Python web application"
	@echo "  make clean          - Clean up environments, databases, and build artifacts"

slides:
	go run golang.org/x/tools/cmd/present@latest -notes -play=false

export-slides:
	./scripts/export_slides.sh public

docker-slides:
	docker build -t vibecoding-slides .
	docker run -it --rm -p 3999:3999 vibecoding-slides

run-2048:
	@cd 2048 && $(MAKE) run

clean:
	@cd 2048 && $(MAKE) clean
	@rm -rf public dist
