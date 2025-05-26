# ────────────────────
# 🔥 FIREBASE COMMANDS
# ────────────────────
.PHONY: help-fire
help-fire: ## Show all available Firebase-related commands
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: init-firebase
init-firebase: fire-login configure ## Initialize Firebase for this project

.PHONY: fire-login
fire-login: ## Login and initialize Firebase CLI
	@echo "🔑 Installing Firebase CLI..."
	@(curl -sL https://firebase.tools | bash)
	@echo "🔓 Logging into Firebase..."
#	@(curl -sL https://firebase.tools | upgrade=true bash)
#	@firebase logout
	@firebase login
	@echo "⚙️ Initializing Firebase project..."
	@firebase init

.PHONY: configure
configure: ## Configure FlutterFire for the project
	@echo "📦 Activating flutterfire_cli..."
	@dart pub global activate flutterfire_cli
	@echo "🛠️ Running flutterfire configuration..."
	@flutterfire configure \
		-i ru.raintv.rain \
		-a ru.raintv.rain \
		-p tv-rain-mobile \
		-e "" \
		-o lib/src/common/constant/firebase_options.g.dart
