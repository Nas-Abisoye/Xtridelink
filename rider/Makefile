.PHONY: cleanBuild pubGet buildApk

pubGet:
	@echo "Refreshing build"
	fvm flutter pub get


cleanBuild:
	@echo "Clean build"
	fvm flutter clean
	cd ios && rm -rf Podfile.lock
	cd ios && rm -rf Pods
	fvm flutter pub get
	cd ios && pod install


buildApk:
	@echo "Building Apk..."
	fvm flutter build apk  --debug

buildProdApk:
	@echo "Building Apk..."
	flutter build apk


gen: ## Generates the assets
	@echo "╠ Generating the assets..."
	@flutter pub get
	@flutter packages pub run build_runner build 

gen_delete: ## Generates the assets
	@echo "╠ Generating the assets..."
	@flutter pub get
	@flutter pub run build_runner build --delete-conflicting-outputs

build_gen: ## Generates the assets
	@echo "╠ Generating files..."
	@flutter pub run build_runner build