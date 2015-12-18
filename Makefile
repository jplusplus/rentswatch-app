install:
	npm install
	bower install

run:
	grunt serve

build:
	grunt --force

deploy: build
	heroku docker:release -a rentswatch-app

prefetch:
	node server/commands/scatterplot.js --output=./server/cache/all.png
	node server/commands/stats.js --output=./server/cache/stats.json
