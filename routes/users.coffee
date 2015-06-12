express = require 'express'
router = express.Router()
model = require '../model/model'
router.use require('body-parser').urlencoded(extended: false)
util = require '../util'

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
		if err
			res.render 'message',
							page: "Failure"
							type: "bad"
							message: err
							link: "#{viewDir}/register"
							label: "Return"
		else
			res.render 'message',
							page: "Success"
							type: "good"
							message: "Account created successfully."
							link: "#{viewDir}"
							label: "Go to profile"

router.get '/', (req, res) ->
	unless req.session.user?
		res.render 'message',
						page: "NoUser"
						type: "bad"
						message: "Not logged in!"
						link: "/"
						label: "Return"
		return

	u = req.session.user

	res.render "#{viewDir}/index", u





module.exports = router
