#!/user/bin/env coffee
express = require 'express'
app = require('express')()
socket  = require 'socket.io'
http    = require('http').Server(app)
mongodb = require('mongodb').MongoClient
ObjectId = require('mongodb').ObjectID

app.use('/', express.static('./client-react/build/'))

io = socket http

io.on 'connection', (socket) -> 
  console.log "User connect"
  userUrl = null

  socket.on "connectTo", (data) ->
    console.log "ala", data
    userUrl = 'mongodb://' +data.url + '/'

    mongodb.connect userUrl, (err, db) ->
      if err then console.log err  
      else db.admin().listDatabases (err, dat) ->
        if err then socket.emit 'error',  {data: err }  
        else 
          socket.emit 'dbs', { array: dat}
          db.close()

  socket.on 'addDb', (data) ->
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.admin().listDatabases (err, dat) ->
        if err then socket.emit 'error',  {data: err }  
        else 
          socket.emit 'dbs', { array: dat}
          db.close()

  socket.on 'dropDb', (data)->
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.dropDatabase (err, dat) -> 
        if err then socket.emit 'error',  {data: err }  
        else 
          socket.emit 'removed', { data: true }
          db.close()
    
  socket.on 'listCol', (data) ->
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.listCollections().toArray (err, dat) -> 
        if err then socket.emit 'error',  {data: err }  
        else 
          socket.emit 'collections', { data: dat }
          db.close()
  
  socket.on 'addCol', (data) ->
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.createCollection data.col, (err, dat) -> 
        if err then socket.emit 'error',  {data: err }  
        else 
          db.listCollections().toArray (err, dat) -> 
            if err then socket.emit 'error',  {data: err }  
            else 
              socket.emit 'collections', { data: dat }
              db.close()
  
  socket.on 'delCol', (data) ->
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.collection(data.col).drop (err, dat) -> 
        if err then socket.emit 'error',  {data: err }  
        else 
          db.listCollections().toArray (err, dat) -> 
            if err then socket.emit 'error',  {data: err }  
            else 
              socket.emit 'collections', { data: dat }
              db.close()
  
  socket.on 'listDoc', (data) ->
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.collection(data.col).find({}).toArray (err, dat)  ->
        if err then socket.emit 'error',  {data: err }  
        else 
          socket.emit 'docs', {data: data}
          db.close()
  
  socket.on 'update', (data) ->
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.collection(data.col).updateOne {_id: new ObjectID(data._id)}, data.updated, (err, result) ->
        if (err) then socket.emit 'error',  {data: err } 
        else 
          socket.emit 'doneUpdate',  {data: true}
  
  socket.on 'inset', (data) -> 
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.collection(data.col).insetOnce data.obj, (err, dat)  ->
        if err then socket.emit 'error',  {data: err }  
        else 
          db.collection(data.col).find({}).toArray (err, dat)  ->
            if err then socket.emit 'error',  {data: err }  
            else 
              socket.emit 'docs', {data: data}
              db.close()
              
  socket.on 'remove', (data) ->
    mongodb.connect userUrl + data.name, (err, db) ->
      if err then socket.emit 'error',  {data: err }  
      else db.collection(data.col).deleteOne {_id: new ObjectId(data._id)}, (err, dat) ->
        if err then socket.emit 'error',  {data: err }
        else
          db.collection(data.col).find({}).toArray (err, dat)  ->
            if err then socket.emit 'error',  {data: err }  
            else 
              socket.emit 'docs', {data: data}
              db.close()
      

  undefined

http.listen 3000,  ->
  console.log('3000')