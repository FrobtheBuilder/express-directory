express = require 'express'
router = express.Router()
model = require '../model/model'
config = require '../config'

router.use require('body-parser').urlencoded(extended: false)
util = require '../util'

middleware = util.middleware

fs = require 'fs'

viewDir = "picture"
storagePath = "./public/img" # relative to process.cwd() which is the parent directory

module.exports = router

if config.environment is "development"
	router.use middleware.getDevUser(name: "Frob")

router.use middleware.checkUser

router.use middleware.aliasUser

router.get '/cwd', (req, res) ->
	console.log process.cwd()
	res.end("hi")


router.get '/upload', (req, res) ->
	res.render "#{viewDir}/upload"

router.post '/upload', (req, res) ->
	unless req.files.picture?
		res.render 'message', util.message.bad "No image.", "#{viewDir}/upload"

	u = req.session.user
	p = req.files.picture

	newPic = 
		new model.Picture
			title: req.body.title
			_owner: u._id
			path: p.path
			type: p.extension

	newPic.save (err) ->
		if err?
			res.render 'message', util.message.bad "#{err}", "#{viewDir}/upload"
		res.end("dun")

	#model.User.findOne(_id: u._id).exec (err, user) ->
	#	user.pictures.push
	###
	fs.mkdir "#{storagePath}/#{u.name}", ->
		fs.rename p.path, "#{storagePath}/#{u.name}/#{p.name}", ->
			res.render 'message',
				page: "Uploaded"
				type: "good"
				message: "File uploaded!"
				label: "Return"
				link: "/"
	console.log "#{storagePath}/#{u.name}/#{p.name}"
	###


