'use strict'
extend = require 'extend'
XMLNode = require './xml'

SVG = module.exports = class
	constructor: ->
		@width = 100
		@height = 100
		@svg = XMLNode 'svg'
		@context = [] # Track nested nodes
		@setAttributes @svg,
			xmlns: 'http://www.w3.org/2000/svg'
			width: @width
			height: @height
		this

	# This is a hack so groups work.
	currentContext: ->
		@context[@context.length - 1] or @svg

	# This is a hack so groups work.
	end: ->
		@context.pop()
		this

	currentNode: ->
		context = @currentContext()
		context.lastChild or context

	transform: (transformations) ->
		@currentNode().setAttribute 'transform', Object.keys(transformations).map((transformation) ->
			transformation + '(' + transformations[transformation].join(',') + ')'
		).join(' ')
		this

	setAttributes: (el, attrs) ->
		Object.keys(attrs).forEach (attr) ->
			el.setAttribute attr, attrs[attr]

	setWidth: (width) ->
		@svg.setAttribute 'width', Math.floor(width)

	setHeight: (height) ->
		@svg.setAttribute 'height', Math.floor(height)

	toString: ->
		@svg.toString()

	rect: (x, y, width, height, args) ->
		# Accept array first argument
		if Array.isArray x
			x.forEach (a) =>
				@rect.apply self, a.concat(args)

			return this
		rect = XMLNode 'rect'
		@currentContext().appendChild rect
		@setAttributes rect, extend(
			x: x
			y: y
			width: width
			height: height
		, args)
		this

	circle: (cx, cy, r, args) ->
		circle = XMLNode 'circle'
		@currentContext().appendChild circle
		@setAttributes circle, extend(
			cx: cx
			cy: cy
			r: r
		, args)
		this

	path: (str, args) ->
		path = XMLNode 'path'
		@currentContext().appendChild path
		@setAttributes path, extend(
			d: str
		, args)
		this

	polyline: (str, args) ->
		# Accept array first argument
		if Array.isArray(str)
			str.forEach (s) =>
				@polyline s, args
				return

			return this
		polyline = XMLNode 'polyline'
		@currentContext().appendChild polyline
		@setAttributes polyline, extend(
			points: str
		, args)
		this

	# group and context are hacks
	group: (args) ->
		group = XMLNode 'g'
		@currentContext().appendChild group
		@context.push group
		@setAttributes group, extend({}, args)
		this
