express = require 'express'
app = express()
bodyParser = require 'body-parser'
session = require 'express-session'
json = require 'express-json'

config = require './config.json'
model = require './model/model'

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

app.use '/user', (require './routes/users').unauthed
app.use '/user', (require './routes/users').router
app.use '/picture', require './routes/pictures'
app.use '/test', require './routes/test'

app.get '/', (req, res) ->
	res.render 'index', page: "Index"

app.listen config.port, ->
	console.log "server running on #{config.port}"
