express = require 'express'

router = express.Router()
async = express.Router()

model = require '../model/model'
router.use require('body-parser').urlencoded(extended: false)
util = require '../util'
config = require '../config'
_ = require 'lodash'

viewDir = "user"

## TRADITIONAL API ##

# registration page
router.get '/register', (req, res) ->
	res.render "#{viewDir}/register", page: "Register"

# new user creation
router.post '/', (req, res) ->
	b = req.body

	unless b.username.length > 0 and
	b.email.length > 0 and
	#util.emailRegex.test b.email and
	b.password is b.confirm
		res.render 'message', (util.message.bad "Invalid info.", "#{viewDir}/register")
		return

	req.session.user = 
		new model.User
			name: req.body.username
			email: req.body.email
			password: util.hash.toSHA1 req.body.password
			pictures: []

	u = req.session.user

	u.save (err) ->
		msg = if err
			page: "Failure"
			type: "bad"
			message: err
			link: "#{viewDir}/register"
			label: "Return"
		else
			page: "Success"
			type: "good"
			message: "Account created successfully."
			link: "#{viewDir}"
			label: "Go to profile"

		res.render 'message', msg

# page for logged in user
router.get '/', (req, res) ->

	render = ->
		res.render "#{viewDir}/index", user: req.session.user, isSelf: true

	if config.environment is "development"
		model.User.findOne(name: "ayy").exec (err, user) ->
			req.session.user = user
			render()
	else
		unless req.session.user?
			res.render 'message', util.message.noSession
			return
		render()

# page for user by object id hex string
router.get '/:id', (req, res) ->
	model.User.findPopulated _id: req.params.id, (err, user) ->
		if err?
			res.render 'message', util.message.bad "No user by that ID", "/"
			return

		res.render "#{viewDir}/index", user: user, isSelf: false


# pretty self-explanitory
router.post '/login', (req, res) ->
	model.User
	.findOne(name: req.body.username)
	.populate('pictures profilePicture')
	.exec (err, user) ->

		unless user?
			res.render 'message', util.message.bad "No user!", "/"
			return

		unless user.password is util.hash.toSHA1 req.body.password
			res.render 'message', util.message.bad "Wrong password!", "/"
			return

		console.log req.body.username
		console.log(JSON.stringify err) if err?
		req.session.user = user
		res.redirect "/user"

router.get '/logout', (req, res) ->
	req.session.user = null
	res.redirect '/' #and then, ya get outta there!


## ASYNC API ##
router.use '/async', async

# return a json object of the user in the get query's "name" field
# return {success: true, user: user} or {success: false, reason: "whatever"}
async.get '/', (req, res) ->
	unless req.session.user?
		res.json
			success: false
			reason: "Not logged in!"

	model.User.findOne(name: req.query.name).exec (err, user) ->
		res.json
			success: true
			user: user

# edit a user, accepts a urlencoded request with a "change" param and a "to" param
# return {success: true, user: user} or {success: false, reason: "whatever"}
async.post '/', (req, res) ->

	respond = (err, u) ->
		re = if err?
			success: false
			reason: err
		else
			success: true
			user: u

		res.json re

	toChange = req.body.change
	to = req.body.to

	unless req.session.user?
		res.json
			success: false
			reason: "Not logged in!"

	unless _.contains ["name", "email", "info", "password"], toChange
		res.json
			success: false
			reason: "attempt to change invalid attribute #{toChange}"

	model.User.findOne(_id: req.session.user._id).exec (err, user) ->
		user[toChange] = if toChange is "password" then util.hash.toSha1(to) else to
		user.save (err) ->
			respond err, user


module.exports = router
