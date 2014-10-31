'use strict'

Pattern = require './pattern'

###
	Normalize arguments, if not given, to:
	string: (new Date()).toString()
	options: {}
###
optArgs = (cb) ->
	(string, options) ->
		if typeof string is 'object'
			options = string
			string = null
		string = (new Date()).toString() unless string?
		options = {} unless options
		cb.call @, string, options

GeoPattern = module.exports = generate: optArgs((string, options) ->
	new Pattern string, options
)

if $?
	$.fn.geopattern = optArgs (string, options) ->
		@each ->
			titleSha = ($ @).attr 'data-title-sha'
			if titleSha
				options = $.extend
					hash: titleSha
				, options
			pattern = GeoPattern.generate(string, options)
			($ @).css 'background-image', pattern.toDataUrl()