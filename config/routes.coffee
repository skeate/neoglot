module.exports = (app, passport) ->
  users = require('../app/controllers/users') app
  languages = require('../app/controllers/languages') app
  words = require('../app/controllers/words') app
  pages = require('../app/controllers/pages') app
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
      res.send 200
    else
      res.send 401
  app.post '/login', (req, res, next) ->
    plocal = passport.authenticate 'local', (err, user, info) ->
      if err then next err
      else if !user then res.send 401, info
      else
        req.logIn user, (err) ->
          if err then next err
          else
            res.send 200
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
  app.get '/api/languages/:start/:count', languages.list
  # Search languages
  app.get '/api/languages/search/:search/:start/:count', languages.search
  # Get language info
  app.get '/api/languages/:language', languages.read
  # Get languages for logged in user
  app.get '/api/mylanguages', auth, languages.listOwn
  app.get '/api/mylanguages/:language', auth, languages.readOwn


  ## UPDATE
  app.put '/api/mylanguages/:language', auth, languages.update
  ## DELETE
  app.delete '/api/mylanguages/:language', auth, languages.delete

  #---- Words -----------------------------------------------------------------#
  ## CREATE
  app.post '/api/words', auth, words.create

  ## READ
  # Search for a word
  app.get '/api/words/:language/:search', words.search
  # List words in a language
  app.get '/api/words/:language/:start/:count', words.list

  ## UPDATE
  app.put '/api/words/:word', auth, words.update
  ## DELETE
  app.delete '/api/words/:word', auth, words.delete
  #---- Profiles --------------------------------------------------------------#
  ## READ
  app.get '/api/people/:start/:count', users.list
  app.get '/api/people/:search/:start/:count', users.search
  app.get '/api/people/:user', users.read
  ## UPDATE
  app.put '/api/people', auth, users.update
  ## DELETE
  #app.delete '/api/people/:user', auth, users.delete
  #---- Pages -----------------------------------------------------------------#
  ## CREATE
  app.post '/api/pages/:language/:page', auth, pages.create
  ## READ
  # list
  app.get '/api/pages/:language', pages.list
  # read
  app.get '/api/pages/:language/:page', pages.read
  ## UPDATE
  app.put '/api/pages/:language/:page', auth, pages.update
  ## DELETE
  app.delete '/api/pages/:language/:page', auth, pages.delete

