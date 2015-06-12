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

	if not (b.username.length > 0 and b.email.length > 0 and util.emailRegex.test b.email and b.password is b.confirm)
		res.render 'message',
						page: "Failure"
						bad: true
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





module.exports = router