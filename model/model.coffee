mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

userSchema = new Schema
					no: Number
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
						name: String
						path: String
						type: String

Picture = mongoose.model 'Picture', pictureSchema
User = mongoose.model 'User', userSchema

User.findPopulated = (criteria, callback) ->
	User.findOne(criteria).populate("pictures profilePicture").exec callback

connect = -> mongoose.connect config.mongouri

module.exports =
	connect: connect
	User: User
	Picture: Picture
	ObjectId: Schema.Types.ObjectId