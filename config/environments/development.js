var express = require('express'),
    path = require('path'),
    mongoose = require('mongoose');



module.exports = function (app, passport) {
    app.configure('development', function () {
        app.use(function staticsPlaceholder(req, res, next) {
            return next();
        });

        mongoose.connect('mongodb://localhost/neoglot');
        app.set('port', process.env.PORT || 9000);
        app.set('views', path.join(app.directory, '/app'));
        app.engine('html', require('ejs').renderFile);
        app.set('view engine', 'html');
        app.set('git base', 'A:\\neoglot_testing\\');
        app.use(express.favicon("favicon.ico"));
        app.use(express.logger('dev'));
        app.use(express.bodyParser());
        app.use(express.methodOverride());
        app.use(express.cookieParser('your secret here'));
        app.use(express.session());
        app.use(passport.initialize());
        app.use(passport.session());

        app.use(function middlewarePlaceholder(req, res, next) {
          return next();
        });

        app.use(app.router);
        app.use(express.errorHandler());
    });
};
