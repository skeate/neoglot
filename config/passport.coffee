mongoose = require 'mongoose'
LocalStrategy = require('passport-local').Strategy
User = mongoose.model 'User'

module.exports = (passport) ->
  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findOne _id: id, (err, user) ->
      done err, user

  passport.use new LocalStrategy \
    usernameField: 'email'
    , (username, password, done) ->
      User.findOne email: username, (err, user) ->
        if err
          done err
        else if !user
          done null, false, error: 'Unknown user'
        else if !user.authenticate password
          done null, false, error: 'Invalid password'
        else
          done null, user
