mongoose = require 'mongoose'
Schema = mongoose.Schema

WordSchema = new Schema
  language:
    type: Schema.Types.ObjectId
    index: true
    ref: 'Language'
  word:
    type: String
    index: true
  definitions: [
    pos: String
    definition: String
  ]

mongoose.model 'Word', WordSchema
