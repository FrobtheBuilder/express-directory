MongoClient = require('mongodb').MongoClient
ObjectID = require('mongodb').ObjectID
assert = require 'assert'
url = 'mongodb://localhost:27017/test'

insertDocument = (db, callback) ->
	db.collection('restaurants').insertOne

		'address':
			'street': "Ayy Lmao Dr."
			'zipcode': "80085"
			'building': '1480'
			'coord': [8.8, 8.888]
		'borough': 'manhattan'
		'cuisine': 'Italian'
		'grades': [
			{
				"date" : new Date("2014-10-01T00:00:00Z")
				"grade" : "A"
				"score" : 11
			}
		]
		'name': 'Vella'
		'restaurant_id': '4353453453',
		
		(err, result) ->
			assert.equal err, null
			console.log "Inserted a document into the restaurants collection."
			callback result

findRestaurants = (db, callback) ->
	cursor = db.collection('restaurants').find "address.zipcode": "10075"
	cursor.each (err, doc) ->
		assert.equal err, null
		if doc != null
			console.dir doc
		else
			callback()

MongoClient.connect url, (err, db) ->
	assert.equal null, err
	findRestaurants db, ->
			db.close()