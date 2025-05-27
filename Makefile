# ──────────────────────────────────
# 🧹 CLEAN & GET COMMANDS
# ──────────────────────────────────
.PHONY: clean
clean: ## Clean the project
	@echo "🗑️ Cleaning the project..."
	@flutter clean
	@rm -f coverage.*
	@rm -rf dist bin out build
	@rm -rf coverage .dart_tool .packages pubspec.lock
	@clear
	@echo "✅ Project successfully cleaned"

.PHONY: get
get: ## Get dependencies
	@flutter pub get

.PHONY: fcg
fcg: ## Clean the project and get dependencies
	@make clean
	@make get

# ──────────────────────────────────
# 🎨 CODE STYLE & FORMATTING
# ──────────────────────────────────
.PHONY: fmt
fmt: ## Format Dart code to line length 120
	@dart format -l 120 lib/ test/ packages/ data/

