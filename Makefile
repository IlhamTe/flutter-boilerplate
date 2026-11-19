.PHONY: help setup get slang generate watch run analyze test build-apk build-appbundle build-ios clean rename icons

FLUTTER := fvm flutter
DART := fvm dart
ENV_STAMP := .dart_tool/env.cksum

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-16s %s\n", $$1, $$2}'

setup: ## First run: create .env, get packages, generate code
	@[ -f .env ] || { cp .env.example .env; echo "Created .env from .env.example"; }
	$(MAKE) generate

get: ## flutter pub get
	$(FLUTTER) pub get

slang: ## Generate translations (lib/i18n)
	$(DART) run slang

generate: get slang ## Generate all code (translations, DI, router, models, env, assets)
	@[ -f .env ] || { echo "Missing .env: run make setup"; exit 1; }
	@# build_runner does not track .env: after a .env change it keeps the old values. Clean its cache then.
	@if [ -f .env ] && [ -d .dart_tool/build ] && ! cksum < .env | cmp -s - $(ENV_STAMP); then \
		echo ".env changed, cleaning the build_runner cache..."; \
		$(DART) run build_runner clean; \
	fi
	$(DART) run build_runner build
	@cksum < .env > $(ENV_STAMP)

watch: slang ## Regenerate code on every save
	$(DART) run build_runner watch

run: ## Run the app
	$(FLUTTER) run

analyze: ## Static analysis
	$(FLUTTER) analyze

test: ## Run tests
	$(FLUTTER) test

build-apk: generate ## Release APK
	$(FLUTTER) build apk --release

build-appbundle: generate ## Release Android App Bundle
	$(FLUTTER) build appbundle --release

build-ios: generate ## Release iOS archive
	$(FLUTTER) build ipa --release

clean: ## flutter clean
	$(FLUTTER) clean

icons: ## Generate launcher icons from assets/app_icon (config: icons_launcher in pubspec.yaml)
	$(DART) run icons_launcher:create

rename: ## Rename app name, bundle id and/or Dart package (asks; Enter keeps a value)
	@./tool/rename.sh
