mongoose = require 'mongoose'
Word = mongoose.model 'Word'
Language = mongoose.model 'Language'

module.exports = (app) ->
  create: (req, res) ->
    userOwnsLang = req.user.languages.some (id) ->
      id.toString() == req.body.language.toString()
    if not userOwnsLang
      res.send 401, error: "You cannot create a word for this language."
    else
      word = new Word req.body
      word.save (err, word) ->
        if err then res.send 500, err
        else res.send 200, word
  search: (req, res) ->
    Language.findOne url: req.params.language, '_id', (err, lang) ->
        if err then res.send 500, err
        else
          try
            if req.params.search[0] == '*'
              query = 
                language: lang._id
                definitions: $size: 0
                word: new RegExp '^'+req.params.search.substr(1), 'i'
            else
              query =
                language: lang._id
                word: new RegExp '^'+req.params.search, 'i'
            Word.find(query).sort('word')
              .exec (err, words) ->
                if err then res.send 500, err
                else if words.count > 100 then res.send 500, error: "Too many results"
                else res.send 200, words
          catch err
            console.log err
            res.send 500, err
  list: (req, res) ->
    Language.findOne url: req.params.language, '_id', (err, lang) ->
        if err then res.send 500, err
        else
          Word.find(language: lang._id)
            .sort('word')
            .skip(req.params.start)
            .limit(req.params.count)
            .exec (err, words) ->
              if err then res.send 500, err
              else
                Word.count language: lang._id, (err, count) ->
                  if err then res.send 500, err
                  else res.send 200,
                    count: count
                    words: words
  update: (req, res) ->
    Word.findById req.params.word, (err, word) ->
      if err then res.send 500, err
      else if !word? then res.send 500, error: "Word does not exist."
      else
        userOwnsLang = req.user.languages.some (id) ->
          id.toString() == word.language.toString()
        if not userOwnsLang
          res.send 401, error: "You cannot edit this word."
        else
          delete req.body._id
          word.update req.body, (err) ->
            if err then res.send 500, err
            else res.send 200
  delete: (req, res) ->
    Word.findById req.params.word, (err, word) ->
      if err then res.send 500, err
      else
        userOwnsLang = req.user.languages.some (id) ->
          id.toString() == word.language.toString()
        if not userOwnsLang
          res.send 401, error: "You cannot delete this word."
        else
          word.remove()
          res.send 200
