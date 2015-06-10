express = require 'express'
router = express.Router()

router.get '/register', (req, res) ->
	res.render 'user/register', page: "Register"

module.exports = router