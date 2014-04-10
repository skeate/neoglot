users = require '../app/controllers/users'

module.exports = (app, passport) ->


  auth = (req, res, next) ->
    if !req.isAuthenticated()
      res.send 401
    else
      next()

  app.get '/loggedin', (req, res) ->
    res.send if req.isAuthenticated() then req.user else false
  app.post '/login', (req, res, next) ->
    plocal = passport.authenticate 'local', (err, user, info) ->
      if err then next err
      else if !user then res.send 401, info
      else
        req.logIn user, (err) ->
          if err then next err
          else res.send req.user
    plocal req, res, next
  app.post '/register', users.create
  app.post '/logout', (req, res) ->
    req.logOut()
    res.send 200
  app.get '/api/languages/:lang', auth, (req, res) ->
    res.render 'loading '+req.lang
  app.get '/', (req, res)->
    res.render 'index'
