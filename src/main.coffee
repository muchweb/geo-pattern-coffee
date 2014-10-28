'use strict'

Pattern = require './pattern'

#
# * Normalize arguments, if not given, to:
# * string: (new Date()).toString()
# * options: {}
#
optArgs = (cb) ->
	(string, options) ->
		if typeof string is "object"
			options = string
			string = null
		string = (new Date()).toString()	if string is null or string is `undefined`
		options = {}	unless options
		cb.call this, string, options


GeoPattern = module.exports = generate: optArgs((string, options) ->
	new Pattern(string, options)
)

if $?
	# If jQuery, add plugin
	$.fn.geopattern = optArgs((string, options) ->
		@each ->
			titleSha = $(this).attr("data-title-sha")
			if titleSha
				options = $.extend(
					hash: titleSha
				, options)
			pattern = GeoPattern.generate(string, options)
			$(this).css "background-image", pattern.toDataUrl()
			return

	)