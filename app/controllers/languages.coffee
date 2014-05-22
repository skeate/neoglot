mongoose = require 'mongoose'
User = mongoose.model 'User'
Language = mongoose.model 'Language'
path = require 'path'
mkdirp = require 'mkdirp'
git = require 'gift'
fs = require 'fs'

module.exports = (app) ->
  create: (req, res) ->
    if req.body.description.length > 1000
      res.send 400, error: "Description is too long."
    else
      language = new Language req.body
      language.creator = req.user._id
      language.save (err) ->
        if err then res.send 500, err
        else
          User.findById req.user._id, (err, user) ->
            req.user.languages.push language._id
            user.languages.push language._id
            user.save()
          langdir = path.join app.get('git base'), req.user.display, language.url
          mkdirp langdir, (err) ->
            if err then res.send 500, err
            else
              git.init langdir, (err) ->
                if err then res.send 500, err
                else
                  overviewPath = path.join langdir, "Overview.md"
                  fs.writeFile overviewPath, "", (err) ->
                    if err then res.send 500, err
                    else res.send 200
  list: (req, res) ->
    Language.find()
      .select('url creator name description')
      .sort('name')
      .skip(req.params.start)
      .limit(req.params.count)
      .populate('creator', 'display')
      .exec (err, languages) ->
        if err then res.send 500, err
        else 
          Language.count (err, count) ->
            if err then res.send 500, err
            else res.send 200,
              count: count
              languages: languages
  search: (req, res) ->
    try
      query =
        name: new RegExp '^'+req.params.search, 'i'
      Language.find(query)
        .select('url creator name description')
        .sort('name')
        .skip(req.params.start)
        .limit(req.params.count)
        .populate('creator','display')
        .exec (err, languages) ->
          if err then res.send 500, err
          else
            Language.count query, (err, count) ->
              if err then res.send 500, err
              else res.send 200,
                count: count
                languages: languages
    catch err
      console.log err
      res.send 500, err
  read: (req, res) ->
    Language.findOne(url: req.params.language)
      .select('creator name url description')
      .populate('creator', 'display')
      .exec (err, language) ->
        if err then res.send 500, err
        else res.send 200, language
  listOwn: (req, res) ->
    Language.find {_id: $in: req.user.languages}, 'url name', (err, langs) ->
      if err then res.send 500, err
      else res.send 200, langs
  readOwn: (req, res) ->
    query =
      url: req.params.language
      creator: req.user._id
    Language.findOne query, 'url name description', (err, lang) ->
      if err then res.send 500, err
      else if !lang? then res.send 401, error: "Language not found"
      else res.send 200, lang
  update: (req, res) ->
    if req.body.description.length > 1000
      res.send 400, error: "Description is too long."
    else
      query =
        url: req.params.language
        creator: req.user._id
      delete req.body._id
      Language.findOneAndUpdate query, req.body, select: 'name url description', (err, lang) ->
        if err then res.send 500, err
        else if !lang? then res.send 401, error: "No matching language found or user lacks permissions."
        else res.send 200, lang
  delete: (req, res) ->
    res.send "deleting language"
