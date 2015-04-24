Nodulator = require 'nodulator'

reservationConfig =
  schema:
    userId: 'int'
    articleId: 'int'
    date: 'date'

# class ReservationRoute extends Nodulator.Route.DefaultRoute
#   Config: ->
#     super()

#     @Post '/lol', @Auth(), (req, res) ->
#       res.sendStatus 200

class ReservationResource extends Nodulator.Resource 'reservation', reservationConfig

ReservationResource.Init()

module.exports = ReservationResource
