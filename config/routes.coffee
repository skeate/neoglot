users = require '../app/controllers/users'

module.exports = (app, passport) ->

  app.use passport.initialize()
  app.use passport.session()

  auth = (req, res, next) ->
    if !req.isAuthenticated()
      res.send 401
    else
      next()

  app.get '/loggedin', (req, res) ->
    res.send if req.isAuthenticated() then req.user else false
  app.post '/login', passport.authenticate('local'), (req, res) ->
    res.send req.user
  app.post '/register', users.create
  app.post '/logout', (req, res) ->
    req.logOut()
    res.send 200
  app.get '/api/languages/:lang', auth, (req, res) ->
    res.render 'loading '+req.lang
  app.get '/', (req, res)->
    res.render 'index'
