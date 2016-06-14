install:
	npm install
	bower install

run:
	grunt serve

build:
	grunt --force

deploy: build
	heroku container:push -a rentswatch-app

staging: build
	heroku container:push -a rentswatch-staging

prefetch:
	node server/commands/scatterplot.js --output=./server/cache/all.png

artillery:
	artillery run artillery.json -p artillery.csv
