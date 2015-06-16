mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

userSchema = new Schema
					name: String
					email: String
					password: String
					info: String
					pictures: [{type: Schema.Types.ObjectId, ref: 'Picture'}]
					profilePicture:
						type: Schema.Types.ObjectId, ref: 'Picture'

pictureSchema = new Schema
						title: String
						_owner:
							type: Schema.Types.ObjectId, ref: 'User'
						path: String
						type: String

Picture = mongoose.model 'Picture', pictureSchema
User = mongoose.model 'User', userSchema

connect = -> mongoose.connect config.mongouri

module.exports =
	connect: connect
	User: User
	Picture: Picture