express = require 'express'
app = express()
bodyParser = require 'body-parser'
session = require 'express-session'
json = require 'express-json'

config = require './config.json'
model = require './model/model'
util = require './util'
multer = require 'multer'
helpers = require "./helpers/helpers"
mongoose = require 'mongoose'
#Mongostore = (require 'connect-mongo') session
FileStore = require('session-file-store')(session)
_ = require 'lodash'

## SETTINGS ##
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'

## GLOBAL MIDDLEWARE ##
app.use multer
	dest: "./public/img/"
app.use json()
app.use (require 'connect-assets')(build: false)
app.use express.static(__dirname + '/public')
app.use bodyParser.urlencoded(extended: false)
app.use bodyParser.json()
app.use (req, res, next) ->
	console.log util.reqThings req
	next()

## INITIALIZATION ##
model.connect()

app.use session
	resave: true
	saveUninitialized: true
	secret: "ayy lmao"
	store: (new FileStore())

app.locals = _.merge app.locals, helpers


## ROUTERS ##
app.use '/user', (require './routes/users').unauthed
app.use '/user', (require './routes/users').router
app.use '/picture', require './routes/pictures'
app.use '/test', require './routes/test'


## ROOT ROUTE ##
app.get '/', (req, res) ->
	res.render 'index', page: "Index"

app.listen config.port, ->
	console.log "server running on #{config.port}"
