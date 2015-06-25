crypto = require 'crypto'
model = require './model/model'

exports.logIf = (thing) ->
	if thing? then console.log thing

exports.errorOut = (res, err) ->
	res.render 'message',
		page: 'Error!'
		type: 'bad'
		message: err
		label: 'Return'
		link: '/'
exports.err = (err) ->
		page: 'Error!'
		type: 'bad'
		message: err
		label: 'Return'
		link: '/'

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

exports.anonymous = 
	new model.User
		_id: new model.ObjectId("666")
		name: "Anonymous"

exports.middleware =
	getDevUser: (userCriteria) ->
		return (req, res, next) ->
			unless req.session.user?
				model.User.findPopulated userCriteria, (err, u) ->
					req.session.user = u
					next()
			else
				next()

	getAnonymousUser: ->
		return (req, res, next) ->
			unless req.session.user?
				req.session.user = exports.anonymous
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
		unless req.session.user._id is exports.anonymous._id
			res.locals.me = req.session.user #for use within templates
		next()

