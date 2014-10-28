'use strict'

module.exports = class
	constructor: (tagName) ->
		return new module.exports(tagName)	unless this instanceof module.exports
		@tagName = tagName
		@attributes = Object.create(null)
		@children = []
		@lastChild = null

	appendChild: (child) ->
		@children.push child
		@lastChild = child
		this

	setAttribute: (name, value) ->
		@attributes[name] = value
		this

	toString: ->
		[
			'<'
			@tagName
			(Object.keys @attributes).map((attr) =>
				[
					' '
					attr
					'=\''
					@attributes[attr]
					'\''
				].join ''
			).join('')
			'>'
			@children.map((child) ->
				child.toString()
			).join('')
			'</'
			@tagName
			'>'
	].join ''
