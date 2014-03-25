mongoose = require 'mongoose'
LocalStrategy = require('passport-local').Strategy
User = mongoose.model 'User'

module.exports = (passport) ->
  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findOne _id: id, (err, user) ->
      done err, user

  passport.use new LocalStrategy (username, password, done) ->
    User.findOne username: username, (err, user) ->
      if err
        done err
      else if !user
        done null, false, message: 'Unknown user'
      else if !user.authenticate password
        done null, false, message: 'Invalid password'
      else
        done null, user
