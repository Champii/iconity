_ = require 'underscore'
async = require 'async'

Nodulator = require 'nodulator'

products = require './products'

ReservationResource = require './ReservationResource'

articleConfig =
  # restrict: Nodulator.Route.Auth()
  schema:
    picture:  "string"
    name: "string"
    gender: "string"
    price:  "string"
    mark: "string"
    caution:  "string"
    type: "string"
    registered: "date"
    rentedDate: "array"

class ArticleRoute extends Nodulator.Route.DefaultRoute
  Config: ->
    @Get '/search', (req, res) =>
      @resource.ListBy req.query, (err, instances) =>
        return res.status(500).send err if err?

        res.status(200).send _(instances).invoke 'ToJSON'

    super()

    @Post   (req, res) -> res.sendStatus 404
    @Put    (req, res) -> res.sendStatus 404

    @Put '/:id/rent', @Auth(), (req, res) =>
      if not req.body.date? or not Nodulator.Validator.isDate req.body.date
        return res.status(500).send err: 'Bad date'

      date = new Date(req.body.date)

      if date.toDateString() in @instance.rentedDate
        return res.status(500).send err: 'Already rented'

      ReservationResource.Create
        userId: req.user.id
        articleId: +req.params.id
        date: date.toDateString()
      , (err, rents) =>
        return res.status(500).send err if err?

        @resource.Fetch @instance.id, (err, instance) =>
          return res.status(500).send err if err?

          res.status(200).send instance

class ArticleResource extends Nodulator.Resource 'article', ArticleRoute, articleConfig

  @Deserialize: (blob, done) ->
    if blob.id?
      ReservationResource.ListBy {articleId: blob.id}, (err, rents) =>

        blob.rentedDate = _(rents).pluck 'date'
        super blob, done
    else
      super blob, done

ArticleResource.Init()

module.exports = ArticleResource

async.each products, (item, done) ->
  item.registered = new Date

  ArticleResource.Create item, done
, (err) ->
  return console.error err if err?

