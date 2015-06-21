if module.filename.match /\.(lit)?coffee$/
	# DIY source map support
	require('source-map-support').install
		retrieveSourceMap: require './retrieve_source_map'
else
	# Assume source maps have already been compiled
	require('source-map-support').install()


express = require 'express'
app = express()
bodyParser = require 'body-parser'
session = require 'express-session'
json = require 'express-json'

config = require './config.json'
model = require './model/model'
util = require './util'

app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'

app.use json()
app.use (require 'connect-assets')(build: false)
app.use express.static(__dirname + '/public')
app.use bodyParser.urlencoded(extended: false)
app.use bodyParser.json()
app.use session
	secret: "ayy lmao"

model.connect()

app.use (req, res, next) ->
	console.log util.reqThings req
	next()

app.use '/user', (require './routes/users').unauthed
app.use '/user', (require './routes/users').router
app.use '/picture', require './routes/pictures'
app.use '/test', require './routes/test'

app.get '/', (req, res) ->
	res.render 'index', page: "Index"

app.listen config.port, ->
	console.log "server running on #{config.port}"
