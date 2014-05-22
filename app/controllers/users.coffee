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
  search: (req, res) ->
    try
      query =
        display: new RegExp '^'+req.params.search, 'i'
      User.find(query)
        .select('display languages')
        .sort('display')
        .skip(req.params.start)
        .limit(req.params.count)
        .exec (err, users) ->
          if err then res.send 500, err
          else
            User.count query, (err, count) ->
              if err then res.send 500, err
              else res.send 200,
                count: count
                users: users
    catch err
      console.log err
      res.send 500, err
  list: (req, res) ->
    User.find()
      .select('display languages')
      .sort('display')
      .skip(req.params.start)
      .limit(req.params.count)
      .exec (err, users) ->
        if err then res.send 500, err
        else 
          User.count (err, count) ->
            if err then res.send 500, err
            else res.send 200,
              count: count
              users: users
  read: (req, res) ->
    if req.params.user == '0'
      if req.user?
        User.findById(req.user._id)
          .select('display about')
          .exec (err, user) ->
            if err then res.send 500, err
            else res.send 200, user
      else res.send 401
    else
      User.findOne(display: req.params.user)
        .select('display languages about')
        .populate('languages', 'name url')
        .exec (err, user) ->
          if err then res.send 500, err
          else res.send 200, user
  update: (req, res) ->
    if req.body.about.length > 2000
      res.send 400, error: "About is too long"
    delete req.body._id
    User.findByIdAndUpdate req.user._id, req.body, select: 'about languages display', (err, user) ->
      if err then res.send 500, err
      else res.send 200, user
