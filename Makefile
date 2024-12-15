SOLUTION_DIR = ./Sources/Solutions
SCRIPT_DIR = ./Sources/Scripts

run:
	swift run aoc-24-swift --day $(day)

new:
	@echo "Creating a new solution file..."
	@if [ ! -x $(SCRIPT_DIR)/newday.sh ]; then \
		echo "Script $(SCRIPT_DIR)/newday.sh is not executable. Fixing..."; \
		chmod +x $(SCRIPT_DIR)/newday.sh; \
	fi
	@last_day=$$(ls -1v $(SOLUTION_DIR)/*.swift 2>/dev/null | tail -n 1 | xargs -n 1 basename | sed 's/[^0-9]//g'); \
	next_day=$$((10#$${last_day:-0} + 1)); \
	new_file="$(SOLUTION_DIR)/day$$(printf '%02d' $$next_day).swift"; \
	$(SCRIPT_DIR)/newday.sh $$next_day; \
	echo "Creating $$new_file"; \
	echo "New solution file $$new_file created successfully!"
