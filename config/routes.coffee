module.exports = (app, passport) ->
  users = require('../app/controllers/users') app
  languages = require('../app/controllers/languages') app
  auth = (req, res, next) ->
    if !req.isAuthenticated()
      res.send 401
    else
      next()

  app.get '/', (req, res)->
    res.render 'index'

  ### Authorization handling ###################################################
  app.get '/loggedin', (req, res) ->
    if req.isAuthenticated()
      delete req.user.hashed_password
      res.send req.user
    else
      res.send false
  app.post '/login', (req, res, next) ->
    plocal = passport.authenticate 'local', (err, user, info) ->
      if err then next err
      else if !user then res.send 401, info
      else
        req.logIn user, (err) ->
          if err then next err
          else
            delete req.user.hashed_password
            res.send req.user
    plocal req, res, next
  app.post '/register', users.create
  app.post '/logout', (req, res) ->
    req.logOut()
    res.send 200

  ### API Routing ##############################################################
  #---- Languages -------------------------------------------------------------#
  ## CREATE
  app.post '/api/languages', auth, languages.create

  ## READ
  # List all languages
  app.get '/api/languages', languages.list
  # List all languages by certain user
  app.get '/api/languages/:creator', languages.list
  # Get language info
  app.get '/api/languages/:creator/:language', languages.read
  # Get language info details
  #app.get '/api/languages/:user/:lang', languages.read
  # Get languages for logged in user
  app.get '/api/mylanguages', auth, languages.list
  app.get '/api/mylanguages/:language', auth, languages.read

  ## UPDATE
  app.put '/api/mylanguages/:language', auth, languages.update
  ## DELETE
  app.delete '/api/mylanguages/:language', auth, languages.delete

  #---- Profiles --------------------------------------------------------------#
  ## CREATE
