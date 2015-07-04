marked = require 'marked'
marked.setOptions
	breaks: true
	sanitize: true


module.exports =
	route:
		user:
			id: (id) ->
				"/user/id/#{id}"
	md: marked