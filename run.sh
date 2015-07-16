#!/usr/bin/env bash

if [ $1 = nodemon ]; then
	nodemon --harmony
fi

if [ $1 = createdb ]; then
	docker run --name dirdb -d mongo
fi

if [ $1 = create ]; then
	docker build -t directory .
fi

if [ $1 = docker ]; then
	docker run --name dir --link dirdb:dirdb -p 3000:3000 directory:latest
fi