mongoose = require 'mongoose'
Schema = mongoose.Schema
uniqueValidator = require 'mongoose-unique-validator'

LanguageSchema = new Schema
  name: String
  url: String
  creator: String
  description:
    type: String
    default: "No description given"

LanguageSchema.path('name')
  .validate \
    (value) ->
      value.length
    , 'Language name required'

LanguageSchema.path('url')
  .validate \
    (value) ->
      value.length
    , 'Language URL-friendly name required'

mongoose.model 'Language', LanguageSchema
