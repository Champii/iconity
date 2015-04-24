_ = require 'underscore'
async = require 'async'

Nodulator = require 'nodulator'

products = require './products'

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

    # @Put '/:id/rent', (req, res) =>
    #   console.log 'rent', req.user
    #   if not req.body.date? or not Nodulator.Validator.isDate req.body.date
    #     return res.status(500).send 'Bad date'

    #   if req.body.date in @instance.rentedDate
    #     return res.status(500).send 'Already rented'

    #   @instance.rentedDate.push req.body.date
    #   @instance.Save (err) ->
    #     return res.status(500).send err if err?

    #     res.status(200).send @instance


class ArticleResource extends Nodulator.Resource 'article', ArticleRoute, articleConfig

ArticleResource.Init()

module.exports = ArticleResource

async.each products, (item, done) ->
  item.registered = new Date

  ArticleResource.Create item, done
, (err) ->
  return console.error err if err?

