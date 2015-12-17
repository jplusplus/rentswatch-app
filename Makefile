build:
	grunt build --force

deploy: build
	docker build .
