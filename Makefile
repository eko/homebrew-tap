.PHONY: build-bottle

# Usage: make VERSION=1.0.11 build-bottle
build-bottle:
	brew install --build-bottle eko/homebrew-tap/monday
	brew bottle --json --root-url "https://github.com/eko/monday/releases/download/v${VERSION}/" eko/tap/monday

	mv monday--${VERSION}.catalina.bottle.1.tar.gz monday-${VERSION}.catalina.bottle.tar.gz
	rm monday--${VERSION}.catalina.bottle.json

	@echo "--> upload the following file on release tag: monday-${VERSION}.catalina.bottle.tar.gz" 