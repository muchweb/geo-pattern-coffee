# GeoPattern :coffee: Coffee [![Dependency Status](https://gemnasium.com/muchweb/geo-pattern-coffee.svg)](https://gemnasium.com/muchweb/geo-pattern-coffee) [![NPM version](https://badge.fury.io/js/geo-pattern-coffee.svg)](http://badge.fury.io/js/geo-pattern-coffee) [![Build Status](https://travis-ci.org/muchweb/geo-pattern-coffee.svg)](https://travis-ci.org/muchweb/geo-pattern-coffee)

This is a CoffeeScript port of JavaScript port [btmills/geopattern](https://github.com/btmills/geopattern) of Ruby project [jasonlong/geo_pattern](https://github.com/jasonlong/geo_pattern) that is derived from the background generator originally used for [GitHub Guides](http://guides.github.com/).

## Installation & Building

```
npm install
make
```

## Usage

### Demo page

```
xdg-open docs/geo-pattern-coffee.html
```

### Web

Include the [minified script](js/geo-pattern-coffee.min.js). jQuery is optional.

```HTML
<script src="js/jquery.min.js"></script> <!-- optional -->
<script src="js/geo-pattern-coffee.min.js"></script>
```

Use either the `GeoPattern` browser global or the jQuery plugin:

```JavaScript
// Use the global...
var pattern = GeoPattern.generate('GitHub');
$('#geopattern').css('background-image', pattern.toDataUrl());

// ...or the plugin
$('#geopattern').geopattern('GitHub');
```

For backwards compatibility with the script on the [Guides](http://guides.github.com/), the source hash for generation can be supplied with a `data-title-sha` attribute on the element. If the attribute exists, the generator will ignore the input string and use the supplied hash.

View [`docs/geo-pattern-coffee.html`](docs/geo-pattern-coffee.html) for a complete example.

### Node.js

```bash
npm install geopattern
```

After requiring `geopattern`, the API is identical to the browser version, minus the jQuery plugin.

```js
var GeoPattern = require('geopattern');
var pattern = GeoPattern.generate('GitHub');
pattern.toDataUrl(); // url("data:image/svg+xml;...
```

### API

#### GeoPattern.generate(string, options)

Returns a newly-generated, tiling SVG Pattern.

- `string` Will be hashed using the SHA1 algorithm, and the resulting hash will be used as the seed for generation.

- `options.color` Specify an exact background color. This is a CSS hexadecimal color value.

- `options.baseColor` Controls the relative background color of the generated image. The color is not identical to that used in the pattern because the hue is rotated by the generator. This is a CSS hexadecimal color value, which defaults to `#933c3c`.

- `options.generator` Determines the pattern. [All of the original patterns](https://github.com/jasonlong/geo_pattern#available-patterns) are available in this port, and their names are camelCased.

#### Pattern.toString() and Pattern.toSvg()

Gets the SVG string representing the pattern.

#### Pattern.toBase64()

Gets the SVG as a Base64-encoded string.

#### Pattern.toDataUri()

Gets the pattern as a data URI, i.e. `data:image/svg+xml;base64,PHN2ZyB...`.

#### Pattern.toDataUrl()

Gets the pattern as a data URL suitable for use as a CSS `background-image`, i.e. `url("data:image/svg+xml;base64,PHN2ZyB...")`.

## License ![GPL-3.0+](https://cloud.githubusercontent.com/assets/7157049/4762822/bb25d628-5b07-11e4-8b27-692c75e97759.png)

```
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
