express = require 'express'
app = express()
bodyParser = require 'body-parser'
lessMiddleware = require 'less-middleware'
session = require 'express-session'

config = require './config.json'

app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'

app.use lessMiddleware(__dirname + '/public')
app.use express.static(__dirname + '/public')
app.use bodyParser.urlencoded(extended: false)
app.use bodyParser.json()
app.use session
	secret: "ayy lmao"
app.use '/user', require './routes/users'

app.get '/', (req, res) ->
	res.render 'index', page: "Index"

app.listen config.port, ->
	console.log "server running on #{config.port}"
