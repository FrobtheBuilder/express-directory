express = require 'express'
router = express.Router()
model = require '../model/model'
router.use require('body-parser').urlencoded(extended: false)
util = require '../util'

router.get '/message', (req, res) ->
	res.render 'message',
					page: "Success"
					good: true
					message: "Thing done successfully"
					link: "/"
					label: "Return"

module.exports = router