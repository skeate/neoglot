mongoose = require 'mongoose'
User = mongoose.model 'User'

exports.create = (req, res) ->
  console.log 'in users.create'
  console.log req.body
  user = new User req.body
  user.save (err) ->
    console.log 'user saved. error? :'
    console.log err
    if err
      res.send 401
    else
      console.log 'no error, attempting to login'
      req.logIn user, (err) ->
        console.log 'logged in? :'
        console.log err
        if err
          next err
        else
          res.send 200
