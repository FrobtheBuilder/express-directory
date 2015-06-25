mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'
unique = require 'mongoose-unique-validator'
validators = require './validators'

userSchema = new Schema
					no: Number
					name: String
					email: String
					password: String
					info: String
					pictures: [{type: Schema.Types.ObjectId, ref: 'Picture'}]
					profilePicture:
						type: Schema.Types.ObjectId, ref: 'Picture'

userSchema.plugin unique

pictureSchema = new Schema
						title: String
						_owner:
							type: Schema.Types.ObjectId, ref: 'User'
						name: String
						path: String
						type: String

Picture = mongoose.model 'Picture', pictureSchema

Picture.schema.path('title').validate(validators.length 1, 100)

User = mongoose.model 'User', userSchema

User.schema.path('name').validate(validators.length 1, 30)
User.schema.path('email').validate(validators.length 5, 30)
User.schema.path('password').validate(validators.length 5, 30)
User.schema.path('info').validate(validators.length 0, 500)

User.findPopulated = (criteria, callback) ->
	User.findOne(criteria).populate("pictures profilePicture").exec callback

connect = -> mongoose.connect config.mongouri

module.exports =
	connect: connect
	User: User
	Picture: Picture
	ObjectId: Schema.Types.ObjectId