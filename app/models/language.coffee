mongoose = require 'mongoose'
Schema = mongoose.Schema
uniqueValidator = require 'mongoose-unique-validator'

LanguageSchema = new Schema
  url:
    type: String
    unique: true
  name: String
  creator: 
    type: Schema.Types.ObjectId
    index: true
    ref: 'User'
  description:
    type: String
    default: "No description given"
  #lexicon: [
    #type: Schema.Types.ObjectId
    #ref: 'Word'
  #]

LanguageSchema.plugin uniqueValidator,
  message: '{PATH} already in use.'

LanguageSchema.path('name')
  .validate \
    (value) ->
      value.length
    , 'Language name required'

mongoose.model 'Language', LanguageSchema
