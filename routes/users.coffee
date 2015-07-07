express = require 'express'
marked = require 'marked'
marked.setOptions
	breaks: true
	sanitize: true

router = express.Router()
unauthed = express.Router()
async = express.Router()

model = require '../model/model'
router.use require('body-parser').urlencoded(extended: false)
util = require '../util'
middleware = util.middleware
config = require '../config'
_ = require 'lodash'

viewDir = "user"

## Middleware Setup ##

router.use middleware.getAnonymousUser()
router.use middleware.checkUser
router.use middleware.aliasUser

async.use middleware.checkUserAsync


## TRADITIONAL API ##

# registration page
unauthed.get '/register', (req, res) ->
	res.render "#{viewDir}/register", page: "Register"

# pretty self-explanitory
unauthed.post '/login', (req, res) ->
	model.User
	.findOne(name: req.body.username)
	.exec (err, user) ->

		unless user?
			res.render 'message', util.message.bad "No user!", "/"
			return

		unless user.password is util.hash.toSHA1 req.body.password
			res.render 'message', util.message.bad "Wrong password!", "/"
			return

		req.session.user = user
		res.redirect "/user"


# new user creation
unauthed.post '/', (req, res) ->
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
	if req.session.user._id is util.anonymous._id
		return res.redirect "/"
	model.User.findPopulated _id: req.session.user._id, (err, popUser) ->
		if err? then util.errorOut res, err
		res.render "#{viewDir}/index",
			user: popUser
			isSelf: true


router.get '/browse/:page', (req, res) ->
	model.User.find()
	.sort(_id: -1)
	.skip((req.params.page-1)*50)
	.limit(51).exec (err, users) ->
		unless err?
			res.render "#{viewDir}/browse",
				users: users
				pageNo: req.params.page
				isNext: false
				isPrev: false


# page for user by object id hex string
router.get '/id/:id', (req, res) ->
	model.User.findPopulated _id: req.params.id, (err, user) ->
		if err?
			res.render 'message', util.message.bad "No user by that ID", "/"
			return

		isSelf = String(user._id) == String(req.session.user._id) #ugh.

		res.render "#{viewDir}/index",
			user: user
			isSelf: isSelf


router.get '/logout', (req, res) ->
	req.session.user = null
	return res.redirect '/' #and then, ya get outta there!


## ASYNC API ##
router.use '/async', async


# return a json object of the user in the get query's "name" field
# return {success: true, user: user} or {success: false, reason: "whatever"}
async.get '/', (req, res) ->
	model.User.findOne(name: req.query.name).exec (err, user) ->
		reply = unless err?
			success: true
			user: user
		else
			util.json.fail err

		res.json reply

async.get '/self', (req, res) ->
	model.User.findOne(_id: req.session.user._id).exec (err, user) ->
		reply = unless err?
			success: true
			user: user
		else
			util.json.fail err

		res.json reply

# edit a user, accepts a urlencoded request with a "change" param and a "to" param
# return {success: true, user: user} or {success: false, reason: "whatever"}
async.post '/', (req, res) ->
	toChange = req.body.change
	to = req.body.to

	unless toChange in ["name", "email", "info", "password", "profilePicture"]
		return res.json(util.json.fail "attempt to change invalid attribute #{toChange}")

	model.User.findOne(_id: req.session.user._id).exec (err, user) ->
		user[toChange] = if toChange is "password"
			util.hash.toSha1(to)
		else
			to
		user.save (err) ->
			unless err?
				req.session.user[toChange] = user[toChange]
			reply = unless err?
				success: true
				newValue: (if toChange is "info" then marked(user[toChange]) else user[toChange])
			else
				util.json.fail err

			res.json reply


module.exports =
	router: router
	unauthed: unauthed
