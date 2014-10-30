'use strict'
extend = require 'extend'
color2 = require 'color'
SVG = require './svg'

###*
	Extract a substring from a hex string and parse it as an integer
	@param {string} hash - Source hex string
	@param {number} index - Start index of substring
	@param {number} [length] - Length of substring. Defaults to 1.
###
hexVal = (hash, index, len) ->
	parseInt hash.substr(index, len or 1), 16

#
# * Re-maps a number from one range to another
# * http://processing.org/reference/map_.html
#
map = (value, vMin, vMax, dMin, dMax) ->
	vValue = parseFloat(value)
	vRange = vMax - vMin
	dRange = dMax - dMin
	(vValue - vMin) * dRange / vRange + dMin

fillColor = (val) ->
	(if (val % 2 is 0) then FILL_COLOR_LIGHT else FILL_COLOR_DARK)

fillOpacity = (val) ->
	map val, 0, 15, OPACITY_MIN, OPACITY_MAX

# Use window.btoa if in the browser; otherwise fallback to node buffers
buildHexagonShape = (sideLength) ->
	c = sideLength
	a = c / 2
	b = Math.sin(60 * Math.PI / 180) * c
	[
		0
		b
		a
		0
		a + c
		0
		2 * c
		b
		a + c
		2 * b
		a
		2 * b
		0
		b
	].join ','

# Add an extra one at top-right, for tiling.
# Add an extra row at the end that matches the first row, for tiling.
# Add an extra one at bottom-right, for tiling.
buildChevronShape = (width, height) ->
	e = height * 0.66
	[
		[
			0
			0
			width / 2
			height - e
			width / 2
			height
			0
			e
			0
			0
		]
		[
			width / 2
			height - e
			width
			0
			width
			e
			width / 2
			height
			width / 2
			height - e
		]
	].map (x) ->
		x.join ','

# Add an extra row at the end that matches the first row, for tiling.
buildPlusShape = (squareSize) ->
	[
		[
			squareSize
			0
			squareSize
			squareSize * 3
		]
		[
			0
			squareSize
			squareSize * 3
			squareSize
		]
	]

# Add an extra column on the right for tiling.

# Add an extra row on the bottom that matches the first row, for tiling

# Add an extra one at top-right and bottom-right, for tiling

# Add an extra column on the right for tiling.

# // Add an extra row on the bottom that matches the first row, for tiling.

# These can hang off the bottom, so put a row at the top for tiling.

# Add an extra one at top-right and bottom-right, for tiling

# Add an extra one at top-right, for tiling.

# // Add an extra row at the end that matches the first row, for tiling.

# // Add an extra one at bottom-right, for tiling.
buildOctogonShape = (squareSize) ->
	s = squareSize
	c = s * 0.33
	[
		c
		0
		s - c
		0
		s
		c
		s
		s - c
		s - c
		s
		c
		s
		0
		s - c
		0
		c
		c
		0
	].join ','

# Add an extra one at top-right, for tiling.
buildTriangleShape = (sideLength, height) ->
	halfWidth = sideLength / 2
	[
		halfWidth
		0
		sideLength
		height
		0
		height
		halfWidth
		0
	].join ','

# Add an extra one at top-right, for tiling.
buildDiamondShape = (width, height) ->
	[
		width / 2
		0
		width
		height / 2
		width / 2
		height
		0
		height / 2
	].join ','

# Add an extra one at top-right, for tiling.

# Add an extra row at the end that matches the first row, for tiling.

# Add an extra one at bottom-right, for tiling.
buildRightTriangleShape = (sideLength) ->
	[
		0
		0
		sideLength
		sideLength
		0
		sideLength
		0
		0
	].join ','


drawInnerMosaicTile = (svg, x, y, triangleSize, vals) ->
	triangle = buildRightTriangleShape triangleSize
	opacity = fillOpacity vals[0]
	fill = fillColor vals[0]
	styles =
		stroke: STROKE_COLOR
		"stroke-opacity": STROKE_OPACITY
		"fill-opacity": opacity
		fill: fill

	svg.polyline(triangle, styles).transform
		translate: [
			x + triangleSize
			y
		]
		scale: [
			-1
			1
		]

	svg.polyline(triangle, styles).transform
		translate: [
			x + triangleSize
			y + triangleSize * 2
		]
		scale: [
			1
			-1
		]

	opacity = fillOpacity(vals[1])
	fill = fillColor(vals[1])
	styles =
		stroke: STROKE_COLOR
		"stroke-opacity": STROKE_OPACITY
		"fill-opacity": opacity
		fill: fill

	svg.polyline(triangle, styles).transform
		translate: [
			x + triangleSize
			y + triangleSize * 2
		]
		scale: [
			-1
			-1
		]

	svg.polyline(triangle, styles).transform
		translate: [
			x + triangleSize
			y
		]
		scale: [
			1
			1
		]

	return
drawOuterMosaicTile = (svg, x, y, triangleSize, val) ->
	opacity = fillOpacity(val)
	fill = fillColor(val)
	triangle = buildRightTriangleShape(triangleSize)
	styles =
		stroke: STROKE_COLOR
		"stroke-opacity": STROKE_OPACITY
		"fill-opacity": opacity
		fill: fill

	svg.polyline(triangle, styles).transform
		translate: [
			x
			y + triangleSize
		]
		scale: [
			1
			-1
		]

	svg.polyline(triangle, styles).transform
		translate: [
			x + triangleSize * 2
			y + triangleSize
		]
		scale: [
			-1
			-1
		]

	svg.polyline(triangle, styles).transform
		translate: [
			x
			y + triangleSize
		]
		scale: [
			1
			1
		]

	svg.polyline(triangle, styles).transform
		translate: [
			x + triangleSize * 2
			y + triangleSize
		]
		scale: [
			-1
			1
		]

	return

# Horizontal stripes

# Vertical stripes
buildRotatedTriangleShape = (sideLength, triangleWidth) ->
	halfHeight = sideLength / 2
	[
		0
		0
		triangleWidth
		halfHeight
		0
		sideLength
		0
		0
	].join ","

DEFAULTS = baseColor: "#933c3c"
PATTERNS = [
	"octogons"
	"overlappingCircles"
	"plusSigns"
	"xes"
	"sineWaves"
	"hexagons"
	"overlappingRings"
	"plaid"
	"triangles"
	"squares"
	"concentricCircles"
	"diamonds"
	"tessellation"
	"nestedSquares"
	"mosaicSquares"
	"chevrons"
]
FILL_COLOR_DARK = "#222"
FILL_COLOR_LIGHT = "#ddd"
STROKE_COLOR = "#000"
STROKE_OPACITY = 0.02
OPACITY_MIN = 0.02
OPACITY_MAX = 0.15
Pattern = module.exports = (string, options) ->
	@opts = extend({}, DEFAULTS, options)
	@hash = options.hash or SHA1(string)
	@svg = new SVG()
	@generateBackground()
	@generatePattern()
	this

Pattern::toSvg = ->
	@svg.toString()

Pattern::toString = ->
	@toSvg()

Pattern::toBase64 = ->
	str = @toSvg()
	b64 = undefined
	if typeof window isnt "undefined" and typeof window.btoa is "function"
		b64 = window.btoa(str)
	else
		b64 = new Buffer(str).toString("base64")
	b64

Pattern::toDataUri = ->
	"data:image/svg+xml;base64," + @toBase64()

Pattern::toDataUrl = ->
	"url(\"" + @toDataUri() + "\")"

Pattern::generateBackground = ->
	if @opts.color
		rgb = (color2 @opts.color).rgbString()
	else
		hueOffset = map (hexVal @hash, 14, 3), 0, 4095, 0, 359
		satOffset = hexVal @hash, 17
		baseColor = (color2 @opts.baseColor).hsl()
		baseColor.h = (baseColor.h - hueOffset + 360) % 360

		if satOffset % 2 is 0
			baseColor.s = Math.min 100, baseColor.s + satOffset
		else
			baseColor.s = Math.max 0, baseColor.s - satOffset

		rgb = (color2 baseColor).rgbString()

	@svg.rect 0, 0, '100%', '100%',
		fill: rgb

Pattern::generatePattern = ->
	generator = @opts.generator
	if generator
		throw new Error("The generator #{generator} does not exist.") if (PATTERNS.indexOf generator) < 0

	generator = PATTERNS[hexVal(@hash, 20)]
	this['geo' + (generator.slice 0, 1).toUpperCase() + (generator.slice 1)]()

Pattern::geoHexagons = ->
	scale = hexVal @hash, 0
	sideLength = map scale, 0, 15, 8, 60
	hexHeight = sideLength * (Math.sqrt 3)
	hexWidth = sideLength * 2
	hex = buildHexagonShape sideLength
	@svg.setWidth hexWidth * 3 + sideLength * 3
	@svg.setHeight hexHeight * 6
	i = 0
	y = 0

	while y < 6
		x = 0

		while x < 6
			val = hexVal @hash, i
			dy = (if x % 2 is 0 then y * hexHeight else y * hexHeight + hexHeight / 2)
			opacity = fillOpacity val
			fill = fillColor val
			styles =
				fill: fill
				'fill-opacity': opacity
				stroke: STROKE_COLOR
				'stroke-opacity': STROKE_OPACITY

			@svg.polyline(hex, styles).transform translate: [
				x * sideLength * 1.5 - hexWidth / 2
				dy - hexHeight / 2
			]
			if x is 0
				@svg.polyline(hex, styles).transform translate: [
					6 * sideLength * 1.5 - hexWidth / 2
					dy - hexHeight / 2
				]
			if y is 0
				dy = (if x % 2 is 0 then 6 * hexHeight else 6 * hexHeight + hexHeight / 2)
				@svg.polyline(hex, styles).transform translate: [
					x * sideLength * 1.5 - hexWidth / 2
					dy - hexHeight / 2
				]
			if x is 0 and y is 0
				@svg.polyline(hex, styles).transform translate: [
					6 * sideLength * 1.5 - hexWidth / 2
					5 * hexHeight + hexHeight / 2
				]
			i++
			x++
		y++

Pattern::geoSineWaves = ->
	period = Math.floor(map(hexVal(@hash, 0), 0, 15, 100, 400))
	amplitude = Math.floor(map(hexVal(@hash, 1), 0, 15, 30, 100))
	waveWidth = Math.floor(map(hexVal(@hash, 2), 0, 15, 3, 30))
	fill = undefined
	i = undefined
	opacity = undefined
	str = undefined
	styles = undefined
	val = undefined
	xOffset = undefined
	@svg.setWidth period
	@svg.setHeight waveWidth * 36
	i = 0
	while i < 36
		val = hexVal(@hash, i)
		opacity = fillOpacity(val)
		fill = fillColor(val)
		xOffset = period / 4 * 0.7
		styles =
			fill: "none"
			stroke: fill
			opacity: opacity
			"stroke-width": "" + waveWidth + "px"

		str = "M0 " + amplitude + " C " + xOffset + " 0, " + (period / 2 - xOffset) + " 0, " + (period / 2) + " " + amplitude + " S " + (period - xOffset) + " " + (amplitude * 2) + ", " + period + " " + amplitude + " S " + (period * 1.5 - xOffset) + " 0, " + (period * 1.5) + ", " + amplitude
		@svg.path(str, styles).transform translate: [
			-period / 4
			waveWidth * i - amplitude * 1.5
		]
		@svg.path(str, styles).transform translate: [
			-period / 4
			waveWidth * i - amplitude * 1.5 + waveWidth * 36
		]
		i++
	return

Pattern::geoChevrons = ->
	chevronWidth = map(hexVal(@hash, 0), 0, 15, 30, 80)
	chevronHeight = map(hexVal(@hash, 0), 0, 15, 30, 80)
	chevron = buildChevronShape(chevronWidth, chevronHeight)
	fill = undefined
	i = undefined
	opacity = undefined
	styles = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth chevronWidth * 6
	@svg.setHeight chevronHeight * 6 * 0.66
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			styles =
				stroke: STROKE_COLOR
				"stroke-opacity": STROKE_OPACITY
				fill: fill
				"fill-opacity": opacity
				"stroke-width": 1

			@svg.group(styles).transform(translate: [
				x * chevronWidth
				y * chevronHeight * 0.66 - chevronHeight / 2
			]).polyline(chevron).end()
			if y is 0
				@svg.group(styles).transform(translate: [
					x * chevronWidth
					6 * chevronHeight * 0.66 - chevronHeight / 2
				]).polyline(chevron).end()
			i += 1
			x++
		y++
	return

Pattern::geoPlusSigns = ->
	squareSize = map(hexVal(@hash, 0), 0, 15, 10, 25)
	plusSize = squareSize * 3
	plusShape = buildPlusShape(squareSize)
	dx = undefined
	fill = undefined
	i = undefined
	opacity = undefined
	styles = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth squareSize * 12
	@svg.setHeight squareSize * 12
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			dx = (if (y % 2 is 0) then 0 else 1)
			styles =
				fill: fill
				stroke: STROKE_COLOR
				"stroke-opacity": STROKE_OPACITY
				"fill-opacity": opacity

			@svg.group(styles).transform(translate: [
				x * plusSize - x * squareSize + dx * squareSize - squareSize
				y * plusSize - y * squareSize - plusSize / 2
			]).rect(plusShape).end()
			if x is 0
				@svg.group(styles).transform(translate: [
					4 * plusSize - x * squareSize + dx * squareSize - squareSize
					y * plusSize - y * squareSize - plusSize / 2
				]).rect(plusShape).end()
			if y is 0
				@svg.group(styles).transform(translate: [
					x * plusSize - x * squareSize + dx * squareSize - squareSize
					4 * plusSize - y * squareSize - plusSize / 2
				]).rect(plusShape).end()
			if x is 0 and y is 0
				@svg.group(styles).transform(translate: [
					4 * plusSize - x * squareSize + dx * squareSize - squareSize
					4 * plusSize - y * squareSize - plusSize / 2
				]).rect(plusShape).end()
			i++
			x++
		y++
	return

Pattern::geoXes = ->
	squareSize = map(hexVal(@hash, 0), 0, 15, 10, 25)
	xShape = buildPlusShape(squareSize)
	xSize = squareSize * 3 * 0.943
	dy = undefined
	fill = undefined
	i = undefined
	opacity = undefined
	styles = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth xSize * 3
	@svg.setHeight xSize * 3
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			dy = (if x % 2 is 0 then y * xSize - xSize * 0.5 else y * xSize - xSize * 0.5 + xSize / 4)
			fill = fillColor(val)
			styles =
				fill: fill
				opacity: opacity

			@svg.group(styles).transform(
				translate: [
					x * xSize / 2 - xSize / 2
					dy - y * xSize / 2
				]
				rotate: [
					45
					xSize / 2
					xSize / 2
				]
			).rect(xShape).end()
			if x is 0
				@svg.group(styles).transform(
					translate: [
						6 * xSize / 2 - xSize / 2
						dy - y * xSize / 2
					]
					rotate: [
						45
						xSize / 2
						xSize / 2
					]
				).rect(xShape).end()
			if y is 0
				dy = (if x % 2 is 0 then 6 * xSize - xSize / 2 else 6 * xSize - xSize / 2 + xSize / 4)
				@svg.group(styles).transform(
					translate: [
						x * xSize / 2 - xSize / 2
						dy - 6 * xSize / 2
					]
					rotate: [
						45
						xSize / 2
						xSize / 2
					]
				).rect(xShape).end()
			if y is 5
				@svg.group(styles).transform(
					translate: [
						x * xSize / 2 - xSize / 2
						dy - 11 * xSize / 2
					]
					rotate: [
						45
						xSize / 2
						xSize / 2
					]
				).rect(xShape).end()
			if x is 0 and y is 0
				@svg.group(styles).transform(
					translate: [
						6 * xSize / 2 - xSize / 2
						dy - 6 * xSize / 2
					]
					rotate: [
						45
						xSize / 2
						xSize / 2
					]
				).rect(xShape).end()
			i++
			x++
		y++
	return

Pattern::geoOverlappingCircles = ->
	scale = hexVal(@hash, 0)
	diameter = map(scale, 0, 15, 25, 200)
	radius = diameter / 2
	circle = undefined
	fill = undefined
	i = undefined
	opacity = undefined
	styles = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth radius * 6
	@svg.setHeight radius * 6
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			styles =
				fill: fill
				opacity: opacity

			@svg.circle x * radius, y * radius, radius, styles
			@svg.circle 6 * radius, y * radius, radius, styles  if x is 0
			@svg.circle x * radius, 6 * radius, radius, styles  if y is 0
			@svg.circle 6 * radius, 6 * radius, radius, styles  if x is 0 and y is 0
			i++
			x++
		y++
	return

Pattern::geoOctogons = ->
	squareSize = map(hexVal(@hash, 0), 0, 15, 10, 60)
	tile = buildOctogonShape(squareSize)
	fill = undefined
	i = undefined
	opacity = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth squareSize * 6
	@svg.setHeight squareSize * 6
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			@svg.polyline(tile,
				fill: fill
				"fill-opacity": opacity
				stroke: STROKE_COLOR
				"stroke-opacity": STROKE_OPACITY
			).transform translate: [
				x * squareSize
				y * squareSize
			]
			i += 1
			x++
		y++
	return

Pattern::geoSquares = ->
	squareSize = map(hexVal(@hash, 0), 0, 15, 10, 60)
	fill = undefined
	i = undefined
	opacity = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth squareSize * 6
	@svg.setHeight squareSize * 6
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			@svg.rect x * squareSize, y * squareSize, squareSize, squareSize,
				fill: fill
				"fill-opacity": opacity
				stroke: STROKE_COLOR
				"stroke-opacity": STROKE_OPACITY

			i += 1
			x++
		y++
	return

Pattern::geoConcentricCircles = ->
	scale = hexVal(@hash, 0)
	ringSize = map(scale, 0, 15, 10, 60)
	strokeWidth = ringSize / 5
	fill = undefined
	i = undefined
	opacity = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth (ringSize + strokeWidth) * 6
	@svg.setHeight (ringSize + strokeWidth) * 6
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			@svg.circle x * ringSize + x * strokeWidth + (ringSize + strokeWidth) / 2, y * ringSize + y * strokeWidth + (ringSize + strokeWidth) / 2, ringSize / 2,
				fill: "none"
				stroke: fill
				opacity: opacity
				"stroke-width": strokeWidth + "px"

			val = hexVal(@hash, 39 - i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			@svg.circle x * ringSize + x * strokeWidth + (ringSize + strokeWidth) / 2, y * ringSize + y * strokeWidth + (ringSize + strokeWidth) / 2, ringSize / 4,
				fill: fill
				"fill-opacity": opacity

			i += 1
			x++
		y++
	return

Pattern::geoOverlappingRings = ->
	scale = hexVal(@hash, 0)
	ringSize = map(scale, 0, 15, 10, 60)
	strokeWidth = ringSize / 4
	fill = undefined
	i = undefined
	opacity = undefined
	styles = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth ringSize * 6
	@svg.setHeight ringSize * 6
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			styles =
				fill: "none"
				stroke: fill
				opacity: opacity
				"stroke-width": strokeWidth + "px"

			@svg.circle x * ringSize, y * ringSize, ringSize - strokeWidth / 2, styles
			@svg.circle 6 * ringSize, y * ringSize, ringSize - strokeWidth / 2, styles  if x is 0
			@svg.circle x * ringSize, 6 * ringSize, ringSize - strokeWidth / 2, styles  if y is 0
			@svg.circle 6 * ringSize, 6 * ringSize, ringSize - strokeWidth / 2, styles  if x is 0 and y is 0
			i += 1
			x++
		y++
	return

Pattern::geoTriangles = ->
	scale = hexVal(@hash, 0)
	sideLength = map(scale, 0, 15, 15, 80)
	triangleHeight = sideLength / 2 * Math.sqrt(3)
	triangle = buildTriangleShape(sideLength, triangleHeight)
	fill = undefined
	i = undefined
	opacity = undefined
	rotation = undefined
	styles = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth sideLength * 3
	@svg.setHeight triangleHeight * 6
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			styles =
				fill: fill
				"fill-opacity": opacity
				stroke: STROKE_COLOR
				"stroke-opacity": STROKE_OPACITY

			if y % 2 is 0
				rotation = (if x % 2 is 0 then 180 else 0)
			else
				rotation = (if x % 2 isnt 0 then 180 else 0)
			@svg.polyline(triangle, styles).transform
				translate: [
					x * sideLength * 0.5 - sideLength / 2
					triangleHeight * y
				]
				rotate: [
					rotation
					sideLength / 2
					triangleHeight / 2
				]

			if x is 0
				@svg.polyline(triangle, styles).transform
					translate: [
						6 * sideLength * 0.5 - sideLength / 2
						triangleHeight * y
					]
					rotate: [
						rotation
						sideLength / 2
						triangleHeight / 2
					]

			i += 1
			x++
		y++
	return

Pattern::geoDiamonds = ->
	diamondWidth = map(hexVal(@hash, 0), 0, 15, 10, 50)
	diamondHeight = map(hexVal(@hash, 1), 0, 15, 10, 50)
	diamond = buildDiamondShape(diamondWidth, diamondHeight)
	dx = undefined
	fill = undefined
	i = undefined
	opacity = undefined
	styles = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth diamondWidth * 6
	@svg.setHeight diamondHeight * 3
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			styles =
				fill: fill
				"fill-opacity": opacity
				stroke: STROKE_COLOR
				"stroke-opacity": STROKE_OPACITY

			dx = (if (y % 2 is 0) then 0 else diamondWidth / 2)
			@svg.polyline(diamond, styles).transform translate: [
				x * diamondWidth - diamondWidth / 2 + dx
				diamondHeight / 2 * y - diamondHeight / 2
			]
			if x is 0
				@svg.polyline(diamond, styles).transform translate: [
					6 * diamondWidth - diamondWidth / 2 + dx
					diamondHeight / 2 * y - diamondHeight / 2
				]
			if y is 0
				@svg.polyline(diamond, styles).transform translate: [
					x * diamondWidth - diamondWidth / 2 + dx
					diamondHeight / 2 * 6 - diamondHeight / 2
				]
			if x is 0 and y is 0
				@svg.polyline(diamond, styles).transform translate: [
					6 * diamondWidth - diamondWidth / 2 + dx
					diamondHeight / 2 * 6 - diamondHeight / 2
				]
			i += 1
			x++
		y++
	return

Pattern::geoNestedSquares = ->
	blockSize = map(hexVal(@hash, 0), 0, 15, 4, 12)
	squareSize = blockSize * 7
	fill = undefined
	i = undefined
	opacity = undefined
	styles = undefined
	val = undefined
	x = undefined
	y = undefined
	@svg.setWidth (squareSize + blockSize) * 6 + blockSize * 6
	@svg.setHeight (squareSize + blockSize) * 6 + blockSize * 6
	i = 0
	y = 0
	while y < 6
		x = 0
		while x < 6
			val = hexVal(@hash, i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			styles =
				fill: "none"
				stroke: fill
				opacity: opacity
				"stroke-width": blockSize + "px"

			@svg.rect x * squareSize + x * blockSize * 2 + blockSize / 2, y * squareSize + y * blockSize * 2 + blockSize / 2, squareSize, squareSize, styles
			val = hexVal(@hash, 39 - i)
			opacity = fillOpacity(val)
			fill = fillColor(val)
			styles =
				fill: "none"
				stroke: fill
				opacity: opacity
				"stroke-width": blockSize + "px"

			@svg.rect x * squareSize + x * blockSize * 2 + blockSize / 2 + blockSize * 2, y * squareSize + y * blockSize * 2 + blockSize / 2 + blockSize * 2, blockSize * 3, blockSize * 3, styles
			i += 1
			x++
		y++
	return

Pattern::geoMosaicSquares = ->
	triangleSize = map(hexVal(@hash, 0), 0, 15, 15, 50)
	i = undefined
	x = undefined
	y = undefined
	@svg.setWidth triangleSize * 8
	@svg.setHeight triangleSize * 8
	i = 0
	y = 0
	while y < 4
		x = 0
		while x < 4
			if x % 2 is 0
				if y % 2 is 0
					drawOuterMosaicTile @svg, x * triangleSize * 2, y * triangleSize * 2, triangleSize, hexVal(@hash, i)
				else
					drawInnerMosaicTile @svg, x * triangleSize * 2, y * triangleSize * 2, triangleSize, [
						hexVal(@hash, i)
						hexVal(@hash, i + 1)
					]
			else
				if y % 2 is 0
					drawInnerMosaicTile @svg, x * triangleSize * 2, y * triangleSize * 2, triangleSize, [
						hexVal(@hash, i)
						hexVal(@hash, i + 1)
					]
				else
					drawOuterMosaicTile @svg, x * triangleSize * 2, y * triangleSize * 2, triangleSize, hexVal(@hash, i)
			i += 1
			x++
		y++
	return

Pattern::geoPlaid = ->
	height = 0
	width = 0
	fill = undefined
	i = undefined
	opacity = undefined
	space = undefined
	stripeHeight = undefined
	stripeWidth = undefined
	val = undefined
	i = 0
	while i < 36
		space = hexVal(@hash, i)
		height += space + 5
		val = hexVal(@hash, i + 1)
		opacity = fillOpacity(val)
		fill = fillColor(val)
		stripeHeight = val + 5
		@svg.rect 0, height, "100%", stripeHeight,
			opacity: opacity
			fill: fill

		height += stripeHeight
		i += 2
	i = 0
	while i < 36
		space = hexVal(@hash, i)
		width += space + 5
		val = hexVal(@hash, i + 1)
		opacity = fillOpacity(val)
		fill = fillColor(val)
		stripeWidth = val + 5
		@svg.rect width, 0, stripeWidth, "100%",
			opacity: opacity
			fill: fill

		width += stripeWidth
		i += 2
	@svg.setWidth width
	@svg.setHeight height
	return

Pattern::geoTessellation = ->

	# 3.4.6.4 semi-regular tessellation
	sideLength = map(hexVal(@hash, 0), 0, 15, 5, 40)
	hexHeight = sideLength * Math.sqrt(3)
	hexWidth = sideLength * 2
	triangleHeight = sideLength / 2 * Math.sqrt(3)
	triangle = buildRotatedTriangleShape(sideLength, triangleHeight)
	tileWidth = sideLength * 3 + triangleHeight * 2
	tileHeight = (hexHeight * 2) + (sideLength * 2)
	fill = undefined
	i = undefined
	opacity = undefined
	styles = undefined
	val = undefined
	@svg.setWidth tileWidth
	@svg.setHeight tileHeight
	i = 0
	while i < 20
		val = hexVal(@hash, i)
		opacity = fillOpacity(val)
		fill = fillColor(val)
		styles =
			stroke: STROKE_COLOR
			"stroke-opacity": STROKE_OPACITY
			fill: fill
			"fill-opacity": opacity
			"stroke-width": 1

		switch i
			when 0 # All 4 corners
				@svg.rect -sideLength / 2, -sideLength / 2, sideLength, sideLength, styles
				@svg.rect tileWidth - sideLength / 2, -sideLength / 2, sideLength, sideLength, styles
				@svg.rect -sideLength / 2, tileHeight - sideLength / 2, sideLength, sideLength, styles
				@svg.rect tileWidth - sideLength / 2, tileHeight - sideLength / 2, sideLength, sideLength, styles
			when 1 # Center / top square
				@svg.rect hexWidth / 2 + triangleHeight, hexHeight / 2, sideLength, sideLength, styles
			when 2 # Side squares
				@svg.rect -sideLength / 2, tileHeight / 2 - sideLength / 2, sideLength, sideLength, styles
				@svg.rect tileWidth - sideLength / 2, tileHeight / 2 - sideLength / 2, sideLength, sideLength, styles
			when 3 # Center / bottom square
				@svg.rect hexWidth / 2 + triangleHeight, hexHeight * 1.5 + sideLength, sideLength, sideLength, styles
			when 4 # Left top / bottom triangle
				@svg.polyline(triangle, styles).transform
					translate: [
						sideLength / 2
						-sideLength / 2
					]
					rotate: [
						0
						sideLength / 2
						triangleHeight / 2
					]

				@svg.polyline(triangle, styles).transform
					translate: [
						sideLength / 2
						tileHeight - -sideLength / 2
					]
					rotate: [
						0
						sideLength / 2
						triangleHeight / 2
					]
					scale: [
						1
						-1
					]

			when 5 # Right top / bottom triangle
				@svg.polyline(triangle, styles).transform
					translate: [
						tileWidth - sideLength / 2
						-sideLength / 2
					]
					rotate: [
						0
						sideLength / 2
						triangleHeight / 2
					]
					scale: [
						-1
						1
					]

				@svg.polyline(triangle, styles).transform
					translate: [
						tileWidth - sideLength / 2
						tileHeight + sideLength / 2
					]
					rotate: [
						0
						sideLength / 2
						triangleHeight / 2
					]
					scale: [
						-1
						-1
					]

			when 6 # Center / top / right triangle
				@svg.polyline(triangle, styles).transform translate: [
					tileWidth / 2 + sideLength / 2
					hexHeight / 2
				]
			when 7 # Center / top / left triangle
				@svg.polyline(triangle, styles).transform
					translate: [
						tileWidth - tileWidth / 2 - sideLength / 2
						hexHeight / 2
					]
					scale: [
						-1
						1
					]

			when 8 # Center / bottom / right triangle
				@svg.polyline(triangle, styles).transform
					translate: [
						tileWidth / 2 + sideLength / 2
						tileHeight - hexHeight / 2
					]
					scale: [
						1
						-1
					]

			when 9 # Center / bottom / left triangle
				@svg.polyline(triangle, styles).transform
					translate: [
						tileWidth - tileWidth / 2 - sideLength / 2
						tileHeight - hexHeight / 2
					]
					scale: [
						-1
						-1
					]

			when 10 # Left / middle triangle
				@svg.polyline(triangle, styles).transform translate: [
					sideLength / 2
					tileHeight / 2 - sideLength / 2
				]
			when 11 # Right // middle triangle
				@svg.polyline(triangle, styles).transform
					translate: [
						tileWidth - sideLength / 2
						tileHeight / 2 - sideLength / 2
					]
					scale: [
						-1
						1
					]

			when 12 # Left / top square
				@svg.rect(0, 0, sideLength, sideLength, styles).transform
					translate: [
						sideLength / 2
						sideLength / 2
					]
					rotate: [
						-30
						0
						0
					]

			when 13 # Right / top square
				@svg.rect(0, 0, sideLength, sideLength, styles).transform
					scale: [
						-1
						1
					]
					translate: [
						-tileWidth + sideLength / 2
						sideLength / 2
					]
					rotate: [
						-30
						0
						0
					]

			when 14 # Left / center-top square
				@svg.rect(0, 0, sideLength, sideLength, styles).transform
					translate: [
						sideLength / 2
						tileHeight / 2 - sideLength / 2 - sideLength
					]
					rotate: [
						30
						0
						sideLength
					]

			when 15 # Right / center-top square
				@svg.rect(0, 0, sideLength, sideLength, styles).transform
					scale: [
						-1
						1
					]
					translate: [
						-tileWidth + sideLength / 2
						tileHeight / 2 - sideLength / 2 - sideLength
					]
					rotate: [
						30
						0
						sideLength
					]

			when 16 # Left / center-top square
				@svg.rect(0, 0, sideLength, sideLength, styles).transform
					scale: [
						1
						-1
					]
					translate: [
						sideLength / 2
						-tileHeight + tileHeight / 2 - sideLength / 2 - sideLength
					]
					rotate: [
						30
						0
						sideLength
					]

			when 17 # Right / center-bottom square
				@svg.rect(0, 0, sideLength, sideLength, styles).transform
					scale: [
						-1
						-1
					]
					translate: [
						-tileWidth + sideLength / 2
						-tileHeight + tileHeight / 2 - sideLength / 2 - sideLength
					]
					rotate: [
						30
						0
						sideLength
					]

			when 18 # Left / bottom square
				@svg.rect(0, 0, sideLength, sideLength, styles).transform
					scale: [
						1
						-1
					]
					translate: [
						sideLength / 2
						-tileHeight + sideLength / 2
					]
					rotate: [
						-30
						0
						0
					]

			when 19 # Right / bottom square
				@svg.rect(0, 0, sideLength, sideLength, styles).transform
					scale: [
						-1
						-1
					]
					translate: [
						-tileWidth + sideLength / 2
						-tileHeight + sideLength / 2
					]
					rotate: [
						-30
						0
						0
					]

		i++
	return
