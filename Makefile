all: lib/geo-pattern-coffee.min.js

lib/geo-pattern-coffee.min.js: lib/geo-pattern-coffee.js
	./node_modules/.bin/uglifyjs lib/geo-pattern-coffee.js > lib/geo-pattern-coffee.min.js

lib/geo-pattern-coffee.js: lib/main.js lib/pattern.js lib/svg.js lib/xml.js
	./node_modules/.bin/browserify lib/main.js -o lib/geo-pattern-coffee.js --debug

lib/main.js lib/pattern.js lib/svg.js lib/xml.js: src/main.coffee src/pattern.coffee src/svg.coffee src/xml.coffee
	mkdir -p lib
	./node_modules/.bin/coffee --map --compile --output lib src

clean:
	rm -rf lib