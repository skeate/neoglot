mongoose = require 'mongoose'
User = mongoose.model 'User'
mkdirp = require 'mkdirp'

module.exports = (app) ->
  create: (req, res) ->
    # create user in DB
    user = new User req.body
    user.save (err) ->
      if err
        res.send 401, error: err
      else
        # make the user's git directory
        base = app.get 'git base'
        mkdirp base + user.display, (err) ->
          #log the user in
          if err
            res.send 500, error: err
          else
            req.logIn user, (err) ->
              if err
                res.send 401, error: err
              else
                res.send 200
