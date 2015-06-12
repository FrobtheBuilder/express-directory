mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

userSchema = new Schema
					name: String
					email: String
					insecure_pwd: String
					info: String
					pictures: [{type: Schema.Types.ObjectId, ref: 'Picture'}]

User = mongoose.model 'User', userSchema

pictureSchema = new Schema
						_owner:
							type: Schema.Types.ObjectId
							ref: 'User'
						path: String

Picture = mongoose.model 'Picture', pictureSchema


connect = ->
	mongoose.connect config.mongouri


module.exports =
	connect: connect
	User: User
	Picture: Picture