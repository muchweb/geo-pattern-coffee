all: lib/geopattern.min.js

lib/geopattern.min.js: lib/geopattern.js
	./node_modules/.bin/uglifyjs lib/geopattern.js > lib/geopattern.min.js

lib/geopattern.js: lib/main.js lib/color.js lib/pattern.js lib/svg.js lib/xml.js
	./node_modules/.bin/browserify lib/main.js -o lib/geopattern.js --debug

lib/main.js lib/color.js lib/pattern.js lib/svg.js lib/xml.js:
	./node_modules/.bin/coffee --map --compile --output lib src

clean:
	rm -f lib/main.js    lib/main.js.map
	rm -f lib/color.js   lib/color.js.map
	rm -f lib/pattern.js lib/pattern.js.map
	rm -f lib/svg.js     lib/svg.js.map
	rm -f lib/xml.js     lib/xml.js.map
	rm -f lib/geopattern.js
	rm -f lib/geopattern.min.js