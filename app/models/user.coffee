mongoose = require 'mongoose'
Schema = mongoose.Schema
bcrypt = require 'bcrypt-nodejs'
uniqueValidator = require 'mongoose-unique-validator'

UserSchema = new Schema
  email:
    type: String
    default: ''
    unique: true
  hashed_password:
    type: String
    default: ''
  display:
    type: String
    default: ''
    unique: true
  languages: [
    type: Schema.Types.ObjectId
    ref: 'Language'
  ]
  about: String

UserSchema.plugin uniqueValidator,
  message: '{PATH} already in use.'

UserSchema.virtual('password')
  .set (password) ->
    @_password = password
    @hashed_password = @encryptPassword password
  .get -> @_password

UserSchema.path('display')
  .validate \
    (value) ->
      value.length >= 3
    , 'Display name (at least 3 letters) required'

UserSchema.path('hashed_password')
  .validate \
    (value) ->
      value.length
    , 'Password required.'

UserSchema.path('email')
  .validate \
    (value) ->
      value.length and /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test value
    , 'Valid email required'

UserSchema.methods =
  authenticate: (plainText) ->
    bcrypt.compareSync plainText, @hashed_password
  encryptPassword: (password) ->
    if !password
      return ''
    bcrypt.hashSync password

mongoose.model 'User', UserSchema
