Nodulator = require 'nodulator'
Server = require './server'

Account = require 'nodulator-account'

Nodulator.Use Account

Server.Init()

#CHANGELOG
fs = require 'fs'
Nodulator.app.get '/api/1/changelog', (req, res) ->
  fs.readFile './changelog', (err, file) ->
    return res.status(500).send err if err?

    res.status(200).send file
