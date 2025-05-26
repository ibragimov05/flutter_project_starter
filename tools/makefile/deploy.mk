# ──────────────────────
# 🚀 DEPLOYMENT COMMANDS
# ──────────────────────

# Build Name and Number from pubspec.yaml
BUILD_NAME=$(shell grep '^version: ' pubspec.yaml | cut -d+ -f1 | sed 's/version: //')
BUILD_NUMBER=$(shell grep '^version: ' pubspec.yaml | cut -d+ -f2)

.PHONY: help-deploy
help-deploy: ## Show all available deployment-related commands
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: pre-build
pre-build: increment-build fcg clean_all gen format ## Run before build tasks

# ─────────── VERSION MANAGEMENT ───────────

.PHONY: increment-build
increment-build: ## Increment build number in pubspec.yaml
	@sed -i '' 's/\(^version: *[0-9.]*\)+\([0-9]*\)/\1+'"$$(($$(grep '^version:' pubspec.yaml | cut -d+ -f2) + 1))"'/' pubspec.yaml
	@echo "\nBuild number incremented to $$(($(BUILD_NUMBER) + 1))\n"

.PHONY: ilvi
ilvi: ## Find the last iOS build version in the archive
	@echo "Finding the last iOS build version in the archive..."
	@LAST_ARCHIVE=$(shell ls -td $(ARCHIVE_DIR)/* | head -n 1) && \
	BUILD_VERSION=$$(/usr/libexec/PlistBuddy -c "Print :ApplicationProperties:CFBundleVersion" "$$LAST_ARCHIVE"/Info.plist) && \
	APP_VERSION=$$(/usr/libexec/PlistBuddy -c "Print :ApplicationProperties:CFBundleShortVersionString" "$$LAST_ARCHIVE"/Info.plist) && \
	echo "Last Version Info: $$APP_VERSION - $$BUILD_VERSION"

.PHONY: alvi
alvi: ## Find the last Android build version and app version from local.properties
	@echo "Finding the last Android build version and app version from local.properties..."
	@ANDROID_BUILD_VERSION=$$(grep "versionCode" $(LOCAL_PROPERTIES_FILE) | awk -F '=' '{print $$2}' | xargs) && \
	ANDROID_APP_VERSION=$$(grep "versionName" $(LOCAL_PROPERTIES_FILE) | awk -F '=' '{print $$2}' | xargs) && \
	echo "Last Version Info: $$ANDROID_APP_VERSION - $$ANDROID_BUILD_VERSION"

# ─────────── BUILD COMMANDS FOR ANDROID ───────────

.PHONY: apk
apk: pre-build ## Build Android APK (development config)
	@flutter build apk --release --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/development.json --dart-define=config.platform=android
	@open build/app/outputs/apk/release/

.PHONY: apk-staging
apk-staging: pre-build ## Build Android APK (staging config)
	@flutter build apk --release --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/staging.json --dart-define=config.platform=android
	@open build/app/outputs/apk/release/

.PHONY: apk-prod
apk-prod: pre-build ## Build Android APK (production config)
	@flutter build apk --release --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/production.json --dart-define=config.platform=android
	@open build/app/outputs/apk/release/

# ─────────── BUILD COMMANDS FOR ANDROID aab ───────────

.PHONY: aab
aab: pre-build ## Build Android AAB (development config)
	@flutter build appbundle --dart-define-from-file=config/development.json --dart-define=config.platform=android
	@open build/app/outputs/bundle/release/

.PHONY: aab-staging
aab-staging: pre-build  ## Build Android AAB (staging config)
	@flutter build appbundle --dart-define-from-file=config/staging.json --dart-define=config.platform=android
	@open build/app/outputs/bundle/release/

.PHONY: aab-prod
aab-prod: pre-build ## Build Android AAB (production config)
	@flutter build appbundle --dart-define-from-file=config/production.json --dart-define=config.platform=android
	@open build/app/outputs/bundle/release/

# ─────────── BUILD COMMANDS FOR iOS ───────────

.PHONY: ipa
ipa: pre-build ## Build iOS IPA (development config)
	@flutter build ipa --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/development.json --dart-define=config.platform=ios
	@open build/ios/archive/Runner.xcarchive

.PHONY: ipa-staging
ipa-staging: pre-build ## Build iOS IPA (staging config)
	@flutter build ipa --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/staging.json --dart-define=config.platform=ios
	@open build/ios/archive/Runner.xcarchive

.PHONY: ipa-prod
ipa-prod: pre-build ## Build iOS IPA (production config)
	@flutter build ipa --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/production.json --dart-define=config.platform=ios
	@open build/ios/archive/Runner.xcarchive

# ─────────── PUBLISHING ───────────
.PHONY: publish
publish: ## Publish the app to TestFlight
	@dart run tools/dart/test_flight_publisher.dart
