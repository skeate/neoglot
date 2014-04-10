mongoose = require 'mongoose'
User = mongoose.model 'User'

exports.create = (req, res) ->
  user = new User req.body
  user.save (err) ->
    if err
      res.send 401, error: err
    else
      req.logIn user, (err) ->
        if err
          res.send 401, error: err
        else
          res.send 200
