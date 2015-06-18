express = require 'express'
router = express.Router()
model = require '../model/model'
router.use require('body-parser').urlencoded(extended: false)
util = require '../util'
config = require '../config'

viewDir = "user"

router.get '/register', (req, res) ->
	res.render "#{viewDir}/register", page: "Register"

router.post '/', (req, res) ->
	b = req.body

	unless b.username.length > 0 and
	b.email.length > 0 and
	#util.emailRegex.test b.email and
	b.password is b.confirm
		res.render 'message',
						page: "Failure"
						type: "bad"
						message: "Invalid input"
						link: "#{viewDir}/register"
						label: "Return"
		return

	req.session.user = new model.User
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

module.exports = router
