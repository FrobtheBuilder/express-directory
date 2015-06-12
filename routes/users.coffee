express = require 'express'
router = express.Router()
model = require '../model/model'
router.use require('body-parser').urlencoded(extended: false)


viewDir = "user"

router.get '/register', (req, res) ->
	res.render "#{viewDir}/register", page: "Register"

router.post '/', (req, res) ->
	req.session.user = new model.User
										_id: 666
										name: req.body.username
										email: req.body.email
										insecure_pwd: req.body.password

	req.session.user.save (err) ->
		if err? then console.log err
	
	res.send(JSON.stringify req.session.user)

module.exports = router