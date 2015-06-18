crypto = require 'crypto'

exports.logIf = (thing) ->
	if thing? then console.log thing

exports.hash = 
	toSHA1: (string) ->
		sha = crypto.createHash 'sha1'
		sha.update(string, 'utf8')
		return sha.digest 'hex'

exports.emailRegex = /^(([^<>()[]\.,;:s@"]+(.[^<>()[]\.,;:s@"]+)*)|(".+"))@(([[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}])|(([a-zA-Z-0-9]+.)+[a-zA-Z]{2,}))$/

exports.message =
	bad: (caption, link) ->
		page: 'Failure'
		type: 'bad'
		message: caption
		label: 'Return'
		link: link
	noSession:
		page: 'Failure'
		type: 'bad'
		message: 'Not logged in!'
		label: 'Return'
		link: '/'