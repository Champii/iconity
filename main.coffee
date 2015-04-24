Nodulator = require 'nodulator'
Server = require './server'

Account = require 'nodulator-account'

Nodulator.Use Account

#CHANGELOG
fs = require 'fs'
Nodulator.app.get '/api/1/changelog', (req, res) ->
  fs.readFile './changelog', (err, file) ->
    return res.status(500).send err if err?

    res.status(200).send file

Server.Init()

Nodulator.client.userModel = 'user'
Nodulator.client.Post '/api/1/users',
  "email": "test@test.fr"
  "username": "test"
  "password": "test"
  "picture": "http://placehold.it/32x32"
  "name": "Maricela Dillard"
  "gender": "female"
  "age": 37
  "registered": new Date
  "favorite_article": "shoes"
  "phone": "+1 (819) 553-2105"
, (err, data) ->
  return console.error 'create client', err if err?

  Nodulator.client.SetIdentity 'test', 'test'
  Nodulator.client.Login (err) ->
    return console.error 'login', err if err?

    Nodulator.client.Put '/api/1/articles/1/rent', {date: new Date}, (err, data) ->
      return console.error 'rent put', err if err?

      Nodulator.client.Get '/api/1/articles/1', (err, data) ->
        return console.error 'rent get', err if err?

        console.log data.body
