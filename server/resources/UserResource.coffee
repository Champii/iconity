Nodulator = require 'nodulator'

userConfig =
  restrict: Nodulator.Route.IsOwn('id')
  # fields:
  #   usernameField: 'email'
  schema:
    email: "email"
    username: "string"
    password: "string"
    picture: "string"
    name: "string"
    gender: "string"
    age: "int"
    registered: "string"
    favorite_article: "string"
    phone: "string"

class UserRoute extends Nodulator.Route.DefaultRoute
  Config: ->
    super()

    # @Put '/:id/lol', (req, res) ->
    #   console.log 'rent', req.user
    #   res.sendStatus(200)

class UserResource extends Nodulator.AccountResource 'user', UserRoute, userConfig

UserResource.Init()

module.exports = UserResource

# UserResource.Create
#   "email": "test@test.fr"
#   "username": "test"
#   "password": "test"
#   "picture": "http://placehold.it/32x32"
#   "name": "Maricela Dillard"
#   "gender": "female"
#   "age": 37
#   "registered": new Date
#   "favorite_article": "shoes"
#   "phone": "+1 (819) 553-2105"
# , (err, user) ->
#   return console.error err if err?

