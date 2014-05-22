mongoose = require 'mongoose'
mkdirp = require 'mkdirp'
fs = require 'fs'
path = require 'path'
Language = mongoose.model 'Language'
git = require 'gift'

Array::prepend = (args...) ->
  @splice.apply @, [0,0].concat args
  @

module.exports = (app) ->
  create: (req, res) ->
    query =
      url: req.params.language
      _id: $in: req.user.languages
    Language.findOne query, (err, lang) ->
      if err then res.send 500, err
      else if !lang? then res.send 401, "Language not found or you lack permissions."
      else
        langdir = path.join app.get('git base'), req.user.display, lang.url
        pagepath = path.join langdir, req.params.page+'.md'
        fs.exists pagepath, (exists) ->
          if exists then res.send 500, error: "Page already exists"
          else
            fs.writeFile pagepath, "", (err) ->
              if err then res.send 500, err
              else
                repo = git langdir
                repo.add req.params.page+".md", (err) ->
                  if err then res.send 500, err
                  else
                    repo.commit "new page: "+req.params.page, all: true, (err) ->
                      if err then res.send 500, err
                      else res.send 200
  list: (req, res) ->
    Language.findOne(url: req.params.language)
      .populate('creator', 'display')
      .exec (err, lang) ->
        langdir = path.join app.get('git base'), lang.creator.display, lang.url
        fs.readdir langdir, (err, files) ->
          if err then res.send 500, err
          else res.send 200,
            files.filter((file) -> !!~file.indexOf('.md', file.length - 3))
                 .filter((file) -> file != "Overview.md")
                 .map((file) -> name: file.substr 0, file.length - 3)
                 .prepend name: "Overview"
  read: (req, res) ->
    Language.findOne(url: req.params.language)
      .populate('creator', 'display')
      .exec (err, lang) ->
        langdir = path.join app.get('git base'), lang.creator.display, lang.url
        pagepath = path.join langdir, req.params.page+'.md'
        fs.readFile pagepath, encoding: 'utf8', (err, data) ->
          if err then res.send 500, err
          else res.send 200, data: data
  update: (req, res) ->
    query =
      url: req.params.language
      _id: $in: req.user.languages
    Language.findOne query, (err, lang) ->
      if err then res.send 500, err
      else if !lang? then res.send 401, "Language not found or you lack permissions"
      else
        langdir = path.join app.get('git base'), req.user.display, lang.url
        pagepath = path.join langdir, req.params.page+'.md'
        fs.writeFile pagepath, req.body.markdown, (err) ->
          if err then res.send 500, err
          else
            repo = git langdir
            repo.add req.params.page+".md", (err) ->
              if err then res.send 500, err
              else
                repo.commit "changed page: "+req.params.page, all: true, (err) ->
                  if err then res.send 500, err
                  else res.send 200
  delete: (req, res) ->
    if req.params.page == "Overview"
      res.send 403, error: "Cannot delete Overview page."
    else
      query =
        url: req.params.language
        _id: $in: req.user.languages
      Language.findOne query, (err, lang) ->
        if err then res.send 500, err
        else if !lang? then res.send 401, "Language not found or you lack permissions"
        else
          langdir = path.join app.get('git base'), req.user.display, lang.url
          pagepath = path.join langdir, req.params.page+'.md'
          fs.unlink pagepath, (err) ->
            if err then res.send 500, err
            else
              repo = git langdir
              repo.remove req.params.page+".md", (err) ->
                if err then res.send 500, err
                else
                  repo.commit "deleted page: "+req.params.page, all: true, (err) ->
                    if err then res.send 500, err
                    else res.send 200
