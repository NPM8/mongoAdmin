#!/user/bin/env coffee
express = require 'express'
app = require('express')()
socket  = require 'socket.io'
http    = require('http').Server(app)

app.use('/', express.static('client_react/build'))

io = socket http

io.on 'connection', (socket) -> 
  console.log "User connect"

http.listen 3000,  ->
  console.log('3000')
  undefined