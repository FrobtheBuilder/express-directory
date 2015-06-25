module.exports =
	length: (min, max) ->
		(value) -> min < value.length < max