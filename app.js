require('coffee-script/register');
var express = require('express'),
    passport = require('passport'),
    fs = require('fs'),
    path = require('path');

var app = express();
app.directory = __dirname;

fs.readdirSync('./app/models').forEach(function (file) {
  if (~file.indexOf('.coffee'))
    require('./app/models/' + file)
})

require('./config/passport')(passport);
require('./config/environments')(app, passport);
require('./config/routes')(app, passport);

module.exports = app;
