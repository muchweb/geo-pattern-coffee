'use strict'

module.exports = class

	construct: (tagName) ->
		return new XMLNode tagName unless this instanceof XMLNode
		@tagName = tagName
		@attributes = Object.create null
		@children = []
		@lastChild = null
		this

	appendChild: (child) ->
		@children.push child
		@lastChild = child
		this

	setAttribute: (name, value) ->
		@attributes[name] = value
		this

	toString: ->
		self = this
		[
			'<'
			self.tagName
			(Object.keys self.attributes).map((attr) ->
				[
					' '
					attr
					'="'
					self.attributes[attr]
					'"'
				].join ''
			).join('')
			'>'
			self.children.map((child) ->
				child.toString()
			).join('')
			'</'
			self.tagName
			'>'
		].join ''
