
build:
	grunt --force

deploy: build
	heroku docker:release -a rentswatch-app
