express = require 'express'
app = express()
bodyParser = require 'body-parser'
lessMiddleware = require 'less-middleware'
session = require 'express-session'
coffee = require 'express-coffee-script'

config = require './config.json'
model = require './model/model'

app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'

app.use lessMiddleware(__dirname + '/public')

app.use coffee
	src: 'public/coffee'
	dest: 'public/js'
	prefix: '/js'
	compilerOpts: bare: true

app.use express.static(__dirname + '/public')
app.use bodyParser.urlencoded(extended: false)
app.use bodyParser.json()
app.use session
	secret: "ayy lmao"

model.connect()

app.use '/user', require './routes/users'
app.use '/test', require './routes/test'

app.get '/', (req, res) ->
	res.render 'index', page: "Index"

app.listen config.port, ->
	console.log "server running on #{config.port}"
