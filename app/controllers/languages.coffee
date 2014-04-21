mongoose = require 'mongoose'
Language = mongoose.model 'Language'
path = require 'path'
mkdirp = require 'mkdirp'
git = require 'gift'

module.exports = (app) ->
  create: (req, res) ->
    console.log req.body
    language = new Language req.body
    language.creator = req.user.display
    language.save (err) ->
      if err
        res.send 500, error: err
      else
        langdir = path.join app.get('git base'), req.user.display, language.name
        mkdirp langdir, (err) ->
          if err
            res.send 500, error: err
          else
            git.init langdir, (err) ->
              if err
                res.send 500, error: err
              else
                res.send 200
  list: (req, res) ->
    queryParams = {}
    if req.params.creator?
      queryParams.creator = req.params.creator
    if req.path == '/api/mylanguages'
      queryParams.creator = req.user.display
    Language.find queryParams, (err, languages) ->
      if err
        res.send 500, error: err
      else
        res.send 200, languages
  read: (req, res) ->
    console.log req.path
    console.log req.params.language
    queryParams =
      url: req.params.language
    if req.path == '/api/mylanguages/'+req.params.language
      queryParams.creator = req.user.display
    else
      queryParams.creator = req.params.creator
    Language.find queryParams, (err, language) ->
      if err
        res.send 500, error: err
      else
        res.send 200, language[0]
  update: (req, res) ->
    if req.path == '/api/mylanguages/'+req.params.language
      queryParams =
        url: req.params.language
        creator: req.user.display
      delete req.body._id
      Language.update queryParams, req.body, (err) ->
        if err
          res.send 500, error: err
        else
          res.send 200, req.body
    else
      res.send 401
  delete: (req, res) ->
    res.send "deleting language"
