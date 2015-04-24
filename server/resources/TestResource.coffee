Nodulator = require 'nodulator'

class TestRoute extends Nodulator.Route
  Config: ->
    super()

    @Put '/lol', @Auth(), (req, res) ->
      console.log 'test', req.user
      res.sendStatus 200

class TestResource extends Nodulator.Resource 'test', TestRoute

TestResource.Init()

module.exports = TestResource

# TestResource.Create
#   lol: 'mdr'
# , (err, test) ->
#   return console.error err if err?
