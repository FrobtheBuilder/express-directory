express = require 'express'
router = express.Router()
model = require '../model/model'
config = require '../config'
sharp = require 'sharp'

router.use require('body-parser').urlencoded(extended: false)
util = require '../util'

middleware = util.middleware

fs = require 'fs'

viewDir = "picture"
storagePath = "./public/img" # relative to process.cwd() which is the parent directory
thumbPath = "./public/img/thumb"

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

	processed =
		name: "#{u.name}#{p.name}"
	
	processed.path = "#{storagePath}/#{processed.name}"

	fs.rename p.path, processed.path, ->
		newPic = 
			new model.Picture
				title: req.body.title
				_owner: u._id
				name: processed.name
				path: processed.path
				type: p.extension

		sharp(processed.path).resize(200, 200).toFile("#{thumbPath}/#{processed.name}")
		newPic.save (err) ->
			if err?
				util.errorOut res, err
			res.end "yu dun it"

router.get '/id/:id', (req, res) ->
	model.Picture.findOne(_id: req.params.id).exec (err, picture) ->
		unless picture?
			util.errorOut res, new Error("No Picture by that ID!")
		if err? then util.errorOut res, err