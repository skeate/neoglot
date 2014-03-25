mongoose = require 'mongoose'
Schema = mongoose.Schema
crypto = require 'crypto'

UserSchema = new Schema
  username:
    type: String
    default: ''
  email:
    type: String
    default: ''
  hashed_password:
    type: String
    default: ''
  salt:
    type: String
    default: ''
  display_name:
    type: String
    default: ''

# commented out because whatever runs this doesn't understand latest CS syntax
UserSchema.virtual('password')
  .set (password) ->
    @_password = password
    @salt = @makeSalt()
    @hashed_password = @encryptPassword password
  .get -> @_password

#`
#UserSchema.virtual('password').set(function(password) {
  #this._password = password;
  #this.salt = this.makeSalt();
  #return this.hashed_password = this.encryptPassword(password);
#}).get(function() {
  #return this._password;
#});
#`

UserSchema.virtual('name')
  .get ->
    if @display_name.length > 0
      @display_name
    else
      @username

UserSchema.path('username')
  .validate \
    (value) ->
      value.length
    , 'Username required'

UserSchema.path('email')
  .validate \
    (value) ->
      value.length
    , 'Email required'

UserSchema.pre 'save', (next) ->
  if @password and @password.length
    next()
  else
    next new Error 'Invalid password'

UserSchema.methods =
  authenticate: (plainText) ->
    @hashed_password == @encryptPassword plainText
  makeSalt: -> '' + Math.round new Date().valueOf() * Math.random()
  encryptPassword: (password) ->
    if !password
      return ''
    crypto.createHmac('sha1', @salt)
      .update(password)
      .digest 'hex'

mongoose.model 'User', UserSchema
