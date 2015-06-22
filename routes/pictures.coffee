express = require 'express'
router = express.Router()
model = require '../model/model'
router.use require('body-parser').urlencoded(extended: false)

util = require '../util'
middleware = util.middleware

fs = require 'fs'

viewDir = "picture"
storagePath = "./public/img" # relative to process.cwd() which is the parent directory

module.exports = router

router.get '/cwd', (req, res) ->
	console.log process.cwd()
	res.end("hi")



