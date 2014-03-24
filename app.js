var express = require('express'),
    routes = require('./config/routes'),
    path = require('path');

var app = express();
app.directory = __dirname;

require('./config/environments')(app);
routes(app);

module.exports = app;
