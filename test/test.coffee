GeoPattern = require '..'
SHA1 = require 'sha1'

exports.Constructing =
	'1': (test) ->
		pattern = GeoPattern.generate '1'
		test.strictEqual '7fba32de128f07d33cae5dcfb3e749fb7a10e10a', SHA1 pattern.toDataUrl()
		test.done()

	'2': (test) ->
		pattern = GeoPattern.generate '2'
		test.strictEqual '103a491d146af8f1953fd45b8692a7ac22ed00e7', SHA1 pattern.toDataUrl()
		test.done()

	'3': (test) ->
		pattern = GeoPattern.generate '3'
		test.strictEqual '9bd580ae75778eeb3a52aafa0a2dc5651913a0cd', SHA1 pattern.toDataUrl()
		test.done()

	'4': (test) ->
		pattern = GeoPattern.generate '4'
		test.strictEqual '0dd51f0463c3f5a88c04cd3dcc5cb8d8b3c59fba', SHA1 pattern.toDataUrl()
		test.done()

	'5': (test) ->
		pattern = GeoPattern.generate '5'
		test.strictEqual '58c9e5b8c39577c8718ab96d19af71ad311008b9', SHA1 pattern.toDataUrl()
		test.done()