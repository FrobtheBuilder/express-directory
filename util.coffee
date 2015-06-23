crypto = require 'crypto'
model = require './model/model'

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

exports.json = 
	fail: (reason) ->
		success: false
		reason: reason

exports.reqThings = (req) ->
	method: req.method
	url: req.url
	query: req.query
	params: req.params
	body: req.body
	session: req.session
	files: req.files

exports.middleware =
	getDevUser: (userCriteria) ->
		return (req, res, next) ->
			unless req.session.user?
				model.User.findPopulated userCriteria, (err, u) ->
					req.session.user = u
					next()
			else
				next()

	checkUser: (req, res, next) ->
		unless req.session.user?
			return res.render 'message', exports.message.noSession
		next()

	checkUserAsync: (req, res, next) ->
		unless req.session.user?
			return res.json
				success: false
				reason: "Not logged in!"
		next()

	aliasUser: (req, res, next) ->
		res.locals.me = req.session.user #for use within templates
		next()
